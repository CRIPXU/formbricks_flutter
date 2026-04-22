import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../formbricks_flutter.dart';
import '../../models/environment/logic.dart';
import '../../utils/helper.dart';
import 'components/error.dart';
import 'components/loading.dart';
import 'survey_form.dart';

/// Main Flutter widget that renders a full survey experience for a user.
class SurveyWidget extends StatefulWidget {
  final FormbricksClient client;
  final Survey survey;
  final String userId;
  final int estimatedTimeInSecs;
  final SurveyDisplayMode surveyDisplayMode;
  final VoidCallback? onComplete;
  final bool clickOutsideClose;

  /// Optional custom question widget builders
  final QuestionWidgetBuilder? addressQuestionBuilder;
  final QuestionWidgetBuilder? calQuestionBuilder;
  final QuestionWidgetBuilder? consentQuestionBuilder;
  final QuestionWidgetBuilder? contactInfoQuestionBuilder;
  final QuestionWidgetBuilder? ctaQuestionBuilder;
  final QuestionWidgetBuilder? dateQuestionBuilder;
  final QuestionWidgetBuilder? fileUploadQuestionBuilder;
  final QuestionWidgetBuilder? freeTextQuestionBuilder;
  final QuestionWidgetBuilder? matrixQuestionBuilder;
  final QuestionWidgetBuilder? multipleChoiceMultiQuestionBuilder;
  final QuestionWidgetBuilder? multipleChoiceSingleQuestionBuilder;
  final QuestionWidgetBuilder? npsQuestionBuilder;
  final QuestionWidgetBuilder? pictureSelectionQuestionBuilder;
  final QuestionWidgetBuilder? rankingQuestionBuilder;
  final QuestionWidgetBuilder? ratingQuestionBuilder;

  const SurveyWidget({
    super.key,
    required this.client,
    required this.survey,
    required this.userId,
    required this.estimatedTimeInSecs,
    required this.surveyDisplayMode,
    required this.onComplete,
    required this.clickOutsideClose,
    this.addressQuestionBuilder,
    this.calQuestionBuilder,
    this.consentQuestionBuilder,
    this.contactInfoQuestionBuilder,
    this.ctaQuestionBuilder,
    this.dateQuestionBuilder,
    this.fileUploadQuestionBuilder,
    this.freeTextQuestionBuilder,
    this.matrixQuestionBuilder,
    this.multipleChoiceMultiQuestionBuilder,
    this.multipleChoiceSingleQuestionBuilder,
    this.npsQuestionBuilder,
    this.pictureSelectionQuestionBuilder,
    this.rankingQuestionBuilder,
    this.ratingQuestionBuilder,
  });

  @override
  State<SurveyWidget> createState() => SurveyWidgetState();
}

class SurveyWidgetState extends State<SurveyWidget> {
  /// Tracks current position in the survey.
  int _currentStep = -1; // Used for old question-based surveys
  int _currentBlockIndex = 0;
  int _currentElementIndex = 0;
  bool _useBlocks = false;
  int _currentEndingStep = 0;

  /// Tracks if user has interacted with the survey
  bool hasUserInteracted = false;

  /// Track visited question IDs
  final List<String> _visitedQuestionIds = [];

  /// Local instance of survey to allow mutation
  late Survey survey;

  /// Stores user responses keyed by questionId
  Map<String, dynamic> responses = {};

  /// Stores variable values used in condition evaluation or calculation
  final Map<String, dynamic> _variables = {};

  bool isLoading = true;
  String? error;
  String? displayId;

  final formKey = GlobalKey<FormState>();

  /// Tracks which question is required (based on logic conditions)
  final Map<String, bool> _requiredAnswers = {};

  Timer? _inactivityTimer;
  late int _inactivitySecondsRemaining;

  @override
  void initState() {
    _inactivitySecondsRemaining = widget.survey.autoClose ?? 10;
    hasUserInteracted = false;
    _useBlocks = widget.survey.blocks != null && widget.survey.blocks!.isNotEmpty;

    /// Skip welcome screen if disabled
    if (widget.survey.welcomeCard?['enabled'] == false) {
      if (_useBlocks) {
        _currentBlockIndex = 0;
        _currentElementIndex = 0;
      } else {
        _currentStep++;
      }
    }
    super.initState();
    _fetchSurvey();
    _createDisplay();
    _initializeVariables();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.survey.autoClose != null) {
        _startInactivityTimer(widget.survey.autoClose!);
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  /// Starts the inactivity timer
  void _startInactivityTimer(int seconds) {
    _inactivityTimer?.cancel();
    setState(() => _inactivitySecondsRemaining = seconds);

    _inactivityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_inactivitySecondsRemaining == 1) {
        timer.cancel();
        if (!hasUserInteracted) {
          _closeSurvey();
        }
      } else {
        setState(() => _inactivitySecondsRemaining--);
      }
    });
  }

  /// Called after survey.autoClose seconds of inactivity
  void _closeSurvey() {
    if (mounted) {
      widget.onComplete?.call(); // notify TriggerManager to show next
      Navigator.of(context).maybePop();
    }
  }

  /// Loads the survey data
  void _fetchSurvey() {
    try {
      setState(() {
        survey = widget.survey;
        _useBlocks = survey.blocks != null && survey.blocks!.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  /// Helper to get the current question being displayed
  Question? get _currentQuestion {
    if (_useBlocks) {
      if (_currentBlockIndex >= 0 && _currentBlockIndex < (survey.blocks?.length ?? 0)) {
        final block = survey.blocks![_currentBlockIndex];
        if (_currentElementIndex >= 0 && _currentElementIndex < block.questions.length) {
          return block.questions[_currentElementIndex];
        }
      }
      return null;
    } else {
      return survey.questions?.elementAtOrNull(_currentStep);
    }
  }

  /// Helper to check if we are at the ending screen
  bool get _isAtEnding {
    if (_useBlocks) {
      return _currentBlockIndex >= (survey.blocks?.length ?? 0);
    } else {
      return _currentStep >= (survey.questions?.length ?? 0);
    }
  }

  /// Helper to get all questions for total step calculation
  List<Question> get _allQuestions {
    if (_useBlocks) {
      return survey.blocks?.expand((b) => b.questions).toList() ?? [];
    } else {
      return survey.questions ?? [];
    }
  }

  /// Registers a display session for formbricks analytics/tracking
  Future<void> _createDisplay() async {
    try {
      displayId = await widget.client.createDisplay(surveyId: widget.survey.id, userId: widget.userId);
      if (mounted) {
        context.userManager?.onDisplay(widget.survey.id);
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  /// Callback when a user answers a question
  void _onResponse(String questionId, dynamic value) {
    setState(() {
      responses[questionId] = value;
    });
  }

  /// To avoid multiple submission at a time
  bool _isSubmitting = false;

  /// Submits the survey data to the backend
  Future<void> _submitSurvey() async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    setState(() {
      error = null;
    });

    if (survey.hiddenFields?['enabled'] == true) {
      for (var fieldId in survey.hiddenFields?['fieldIds'] ?? []) {
        if (!responses.containsKey(fieldId)) {
          responses[fieldId] = ''; // or any default value
        }
      }
    }

    try {
      await widget.client.submitResponse(surveyId: widget.survey.id, userId: widget.userId, data: responses);
      if (survey.delay != null) {
        Future.delayed(Duration(seconds: survey.delay!.toInt()), () {
          _closeSurvey();
        });
      }
      if (mounted) {
        context.userManager?.onResponse(widget.survey.id);
        if (kDebugMode) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Survey submitted successfully!')));
        }
      }
    } on SocketException {
      // Internet unavailable
      _cacheUserResponseOnError({'surveyId': widget.survey.id, 'userId': widget.userId, 'data': responses, 'finished': true});
    } on HttpException {
      _cacheUserResponseOnError({'surveyId': widget.survey.id, 'userId': widget.userId, 'data': responses, 'finished': true});
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      _isSubmitting = false;
    }
  }

  /// caching UserResponse on Internet failure or Server issue
  void _cacheUserResponseOnError(Map<String, dynamic> userResponse) {
    context.surveyManager?.setUnSyncUserResponse(userResponse);
  }

  /// Advances to the next question, applying logic if needed
  void nextStep() {
    hasUserInteracted = true;
    final form = formKey.currentState;
    form?.validate();

    /// Show questions if welcome card is enabled
    bool isAtWelcome = _useBlocks
        ? (_currentBlockIndex == 0 && _currentElementIndex == 0 && widget.survey.welcomeCard?['enabled'] == true && !hasUserInteracted)
        : (_currentStep == -1 && survey.welcomeCard?['enabled'] == true);

    // In fact, the previous logic used _currentStep == -1 for welcome.
    // Let's stick to that or similar.
    if (_useBlocks &&
        _currentBlockIndex == 0 &&
        _currentElementIndex == 0 &&
        widget.survey.welcomeCard?['enabled'] == true &&
        responses.isEmpty &&
        _currentStep == -1) {
      setState(() {
        _currentStep = 0;
        _currentBlockIndex = 0;
        _currentElementIndex = 0;
      });
      return;
    }

    if (!_useBlocks && _currentStep == -1 && survey.welcomeCard?['enabled'] == true) {
      setState(() => _currentStep++);
      return;
    }

    final currentQuestion = _currentQuestion;
    if (currentQuestion == null) {
      if (_isAtEnding) {
        _showEnding();
        _submitSurvey();
      }
      return;
    }

    _trackVisit(currentQuestion.id);

    /// Evaluate logic for old structure (Question-level logic)
    if (!_useBlocks && currentQuestion.logic != null && currentQuestion.logic!.isNotEmpty) {
      bool anyLogicMatched = false;
      String? jumpTarget;

      for (final logic in currentQuestion.logic!) {
        if (_evaluateConditions(logic.conditions)) {
          anyLogicMatched = true;
          for (final action in logic.actions) {
            if (action.objective == LogicActionObjective.jumpToQuestion) {
              jumpTarget = action.target;
            } else {
              _executeAction(action);
            }
          }
        }
      }

      if (jumpTarget != null) {
        _jumpToQuestion(jumpTarget);
        return;
      }

      if (anyLogicMatched) {
        if (_requiredAnswers[currentQuestion.id] == true && !responses.containsKey(currentQuestion.id)) {
          form?.validate();
          return;
        }
        _advanceToNextOrEnd();
        return;
      }

      if (currentQuestion.logicFallback != null) {
        _jumpToQuestion(currentQuestion.logicFallback!);
        return;
      }
    }

    /// Block-level logic (New structure)
    if (_useBlocks) {
      final currentBlock = survey.blocks![_currentBlockIndex];

      // If we are at the last element of the block, evaluate block logic
      if (_currentElementIndex == currentBlock.questions.length - 1) {
        if (currentBlock.logic != null && currentBlock.logic!.isNotEmpty) {
          String? jumpTarget;
          for (final logic in currentBlock.logic!) {
            if (_evaluateConditions(logic.conditions)) {
              for (final action in logic.actions) {
                if (action.objective == LogicActionObjective.jumpToBlock) {
                  jumpTarget = action.target;
                } else if (action.objective == LogicActionObjective.jumpToQuestion) {
                  // Some blocks might jump to specific questions?
                  _jumpToQuestion(action.target!);
                  return;
                } else {
                  _executeAction(action);
                }
              }
            }
          }
          if (jumpTarget != null) {
            _jumpToBlock(jumpTarget);
            return;
          }
        }
      }
    }

    /// Default advancement
    if (_requiredAnswers[currentQuestion.id] == true && !responses.containsKey(currentQuestion.id)) {
      form?.validate();
      return;
    }

    _advanceToNextOrEnd();
  }

  /// Moves to the next step or finishes the survey
  void _advanceToNextOrEnd() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() {
      if (_useBlocks) {
        final currentBlock = survey.blocks?[_currentBlockIndex];
        if (currentBlock != null && _currentElementIndex < currentBlock.questions.length - 1) {
          _currentElementIndex++;
        } else {
          _currentBlockIndex++;
          _currentElementIndex = 0;
        }
      } else {
        _currentStep++;
      }
    });

    if (_isAtEnding) {
      _showEnding();
      _submitSurvey();
    }
  }

  /// Moves to a specific block by ID
  void _jumpToBlock(String targetId) {
    final index = survey.blocks?.indexWhere((b) => b.id == targetId) ?? -1;
    setState(() {
      if (index != -1) {
        _currentBlockIndex = index;
        _currentElementIndex = 0;
        final firstQuestionId = survey.blocks?[index].questions.firstOrNull?.id;
        if (firstQuestionId != null) {
          _trackVisit(firstQuestionId);
        }
      } else {
        _showEnding();
        _submitSurvey();
      }
    });
  }

  /// Record the question ID if it hasn't already been recorded as the last entry in the list.
  void _trackVisit(String questionId) {
    if (_visitedQuestionIds.isEmpty || _visitedQuestionIds.last != questionId) {
      _visitedQuestionIds.add(questionId);
    }
  }

  void goBack() {
    if (_visitedQuestionIds.length > 1) {
      _visitedQuestionIds.removeLast(); // remove current
      final previousId = _visitedQuestionIds.last;

      final index = survey.questions?.indexWhere((q) => q.id == previousId);
      if (index != -1) {
        setState(() => _currentStep = index!);
      }
    } else if (_visitedQuestionIds.length == 1 && survey.welcomeCard?['enabled'] == true) {
      setState(() => _currentStep = -1); // Back to welcome
    }
  }

  /// Moves one step back
  void previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  /// Shows the ending screen
  void _showEnding() {
    setState(() {
      _currentStep = (survey.questions?.length ?? 0);
      if (_useBlocks) {
        _currentBlockIndex = (survey.blocks?.length ?? 0);
      }
      _currentEndingStep = 0;
    });
  }

  /// Advances to next part of the ending screen (multi-step ending)
  void _endingStep() {
    setState(() => _currentEndingStep++);
  }

  /// Initializes variables used in logic conditions and calculations
  void _initializeVariables() {
    _variables.addAll({for (var v in survey.variables ?? []) v['id']: v['value']});
  }

  /// Recursively evaluates a a tree of conditions, that can contain mixed types of condition or conditionDetail
  bool _evaluateConditions(dynamic conditions) {
    if (conditions == null || conditions.conditions == null || conditions.conditions.isEmpty) return true;

    final connector = conditions.connector ?? ConditionConnector.and;
    bool result = connector == ConditionConnector.and;

    for (var condition in conditions.conditions) {
      bool conditionResult;

      /// Handle nested group condition (Condition)
      if (condition is Map<String, dynamic> && condition.containsKey('conditions') || condition is Condition) {
        conditionResult = _evaluateConditions(condition is Condition ? condition : Condition.fromJson(condition));
      }
      /// Handle atomic condition (ConditionDetail)
      else if (condition is Map<String, dynamic> && condition.containsKey('operator') || condition is ConditionDetail) {
        final detail = condition is ConditionDetail ? condition : ConditionDetail.fromJson(condition);
        final leftValue = _getOperandValue(detail.leftOperand);
        final rightValue = detail.rightOperand != null ? _getOperandValue(detail.rightOperand!) : null;
        conditionResult = _evaluateCondition(leftValue, detail.operator ?? ConditionOperator.noOperator, rightValue);
      }
      /// Fallback true for unexpected cases
      else {
        conditionResult = true;
      }

      /// Combine results using AND / OR logic
      if (connector == ConditionConnector.and) {
        result = result && conditionResult;
        if (!result) break; // early exit for AND
      } else {
        result = result || conditionResult;
        if (result) break; // early exit for OR
      }
    }

    return result;
  }

  /// Resolves operand values from responses or variables
  dynamic _getOperandValue(Operand operand) {
    switch (operand.type) {
      case OperandType.question:
      case OperandType.element:
        return responses[operand.value] ?? '';
      case OperandType.static:
        return operand.value;
      case OperandType.variable:
        return _variables[operand.value] ?? 0;
    }
  }

  /// Applies basic comparison operators for logic conditions
  bool _evaluateCondition(dynamic left, ConditionOperator operator, dynamic right) {
    ///Picks the left id for comparison for multiple choice and pictureSelection questions
    final currentQuestion = (survey.questions ?? []).elementAtOrNull(_currentStep);
    if (currentQuestion?.type == QuestionType.multipleChoiceSingle ||
        currentQuestion?.type == QuestionType.multipleChoiceMulti ||
        currentQuestion?.type == QuestionType.pictureSelection) {
      String? choiceId = getIdFromChoices(currentQuestion?.choices ?? [], left, currentQuestion?.type == QuestionType.pictureSelection);
      if (choiceId != null) {
        left = choiceId;
      }
    }

    switch (operator) {
      case ConditionOperator.equals:
        return left == right;
      case ConditionOperator.equalsOneOf:
        return (right as List).contains(left.toString());
      case ConditionOperator.isLessThan:
        return num.parse(left.toString()) < num.parse(right.toString());
      case ConditionOperator.isLessThanOrEqual:
        return num.parse(left.toString()) <= num.parse(right.toString());
      case ConditionOperator.isGreaterThan:
        return num.parse(left.toString()) > num.parse(right.toString());
      case ConditionOperator.isGreaterThanOrEqual:
        return num.parse(left.toString()) >= num.parse(right.toString());
      case ConditionOperator.doesNotEqual:
        return left != right;
      case ConditionOperator.contains:
        return left.toString().contains(right.toString());
      case ConditionOperator.doesNotContain:
        return !left.toString().contains(right.toString());
      case ConditionOperator.startsWith:
        return left.toString().startsWith(right.toString());
      case ConditionOperator.doesNotStartWith:
        return !left.toString().startsWith(right.toString());
      case ConditionOperator.endsWith:
        return left.toString().endsWith(right.toString());
      case ConditionOperator.doesNotEndWith:
        return !left.toString().endsWith(right.toString());
      case ConditionOperator.isSubmitted: // Evaluate only at the point of progressing from the specific question
        /// Make sure 'left' refers to a questionId
        if (left is String) {
          return responses.containsKey(left);
        } else if (left is Map && left['value'] is String) {
          return responses.containsKey(left['value']);
        }
        return false;
      case ConditionOperator.isClicked:
        if (left is String) {
          return responses[left] == true || responses[left] == 'clicked';
        }
        return false;
      default:
        return false;
    }
  }

  /// Extracts ID from choices of MultipleChoice questions
  String? getIdFromChoices(List<Map<String, dynamic>> choices, String value, bool isPictureSelection) {
    if (isPictureSelection) {
      for (final choice in choices) {
        if (choice['imageUrl'] == value) {
          return choice['id'];
        }
      }
      return null;
    } else {
      for (final choice in choices) {
        if (translate(choice['label'], context) == value) {
          return choice['id'];
        }
      }
      return null;
    } // Return null if no match found
  }

  /// Executes an action from a logic block
  void _executeAction(LogicAction action) {
    switch (action.objective) {
      case LogicActionObjective.jumpToQuestion:
        _jumpToQuestion(action.target!);
        break;
      case LogicActionObjective.jumpToBlock:
        _jumpToBlock(action.target!);
        break;
      case LogicActionObjective.requireAnswer:
        _requireAnswer(action.target ?? action.variableId);
        break;
      case LogicActionObjective.calculate:
        _calculateValue(action);
        break;
    }
  }

  /// Moves to a specific question by ID
  void _jumpToQuestion(String targetId) {
    _currentStep = (survey.questions ?? []).indexWhere((q) => q.id == targetId);
    if (_currentStep == -1) {
      _showEnding();
      _submitSurvey();
    } else {
      _trackVisit(targetId);
      if (mounted) setState(() {});
    }
  }

  /// Evaluates a calculation and updates the variable value
  void _calculateValue(LogicAction action) {
    final variableId = action.variableId;
    if (variableId == null) return;

    dynamic leftValue = _variables[variableId] ?? 0;
    dynamic rightValue = _getOperandValue(Operand.fromJson(action.value));

    if (leftValue is! num || rightValue is! num) return;

    num result;
    switch (action.operator) {
      case LogicActionOperator.add:
        result = leftValue + rightValue;
        break;
      case LogicActionOperator.subtract:
        result = leftValue - rightValue;
        break;
      case LogicActionOperator.multiply:
        result = leftValue * rightValue;
        break;
      case LogicActionOperator.divide:
        result = rightValue != 0 ? leftValue / rightValue : leftValue;
        break;
      case LogicActionOperator.assign:
        result = rightValue;
        break;
      default:
        result = leftValue;
    }
    _variables[variableId] = result;
  }

  /// Marks a question as required and triggers validation
  void _requireAnswer(String? targetId) {
    final targetQuestion = (survey.questions ?? []).firstWhere(
      (q) => q.id == targetId,
      orElse: () => (survey.questions ?? []).firstWhere(
        (q) => q.id == _variables.keys.firstWhere((k) => _variables[k] == targetId, orElse: () => ""),
        orElse: () => Question(id: '', type: QuestionType.unSupportedType, headline: {}, required: false, logic: []),
      ),
    );
    if (targetQuestion.id.isNotEmpty) {
      _requiredAnswers[targetQuestion.id] = true;
      formKey.currentState?.validate();
      setState(() {});
    }
  }

  /// Builds the main UI of the survey
  @override
  Widget build(BuildContext context) {
    if (isLoading) return SurveyLoading();
    if (error != null && kDebugMode) return SurveyError(errorMessage: error.toString());

    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SurveyForm(
        client: widget.client,
        userId: widget.userId,
        currentStep: _currentStep,
        currentBlockIndex: _currentBlockIndex,
        currentElementIndex: _currentElementIndex,
        isLoading: isLoading,
        formKey: formKey,
        nextStep: nextStep,
        previousStep: goBack,
        onResponse: _onResponse,
        survey: survey,
        responses: responses,
        surveyDisplayMode: widget.surveyDisplayMode,
        requiredAnswers: _requiredAnswers,
        estimatedTimeInSecs: widget.estimatedTimeInSecs,
        currentStepEnding: _currentEndingStep,
        nextStepEnding: _endingStep,
        onComplete: widget.onComplete,
        clickOutsideClose: widget.clickOutsideClose,
        hasUserInteracted: hasUserInteracted,
        inactivitySecondsRemaining: _inactivitySecondsRemaining,
        // Custom widget builders
        calQuestionBuilder: widget.ctaQuestionBuilder,
        consentQuestionBuilder: widget.consentQuestionBuilder,
        contactInfoQuestionBuilder: widget.contactInfoQuestionBuilder,
        ctaQuestionBuilder: widget.ctaQuestionBuilder,
        dateQuestionBuilder: widget.dateQuestionBuilder,
        fileUploadQuestionBuilder: widget.fileUploadQuestionBuilder,
        freeTextQuestionBuilder: widget.freeTextQuestionBuilder,
        matrixQuestionBuilder: widget.matrixQuestionBuilder,
        multipleChoiceMultiQuestionBuilder: widget.multipleChoiceMultiQuestionBuilder,
        multipleChoiceSingleQuestionBuilder: widget.multipleChoiceSingleQuestionBuilder,
        npsQuestionBuilder: widget.npsQuestionBuilder,
        pictureSelectionQuestionBuilder: widget.pictureSelectionQuestionBuilder,
        rankingQuestionBuilder: widget.rankingQuestionBuilder,
        ratingQuestionBuilder: widget.ratingQuestionBuilder,
      ),
    );
  }
}
