import 'package:flutter/material.dart';

import '../../../formbricks_flutter.dart';
import '../../utils/helper.dart';
import 'components/close.dart';
import 'components/content.dart';
import 'end_widget.dart';
import 'question_widget.dart';
import 'welcome_widget.dart';

/// Main survey form widget to handle the rendering and navigation between steps,
/// including welcome screen, questions, and endings.
class SurveyForm extends StatelessWidget {
  // Required survey setup information
  final FormbricksClient client;
  final Survey survey;
  final String userId;

  /// Optional theming override
  final ThemeData? customTheme;

  /// State and navigation tracking
  final int estimatedTimeInSecs;
  final int currentStep;
  final int currentBlockIndex;
  final int currentElementIndex;
  final int currentStepEnding;
  final bool isLoading;
  final String? error;
  final String? displayId;
  final GlobalKey<FormState> formKey;
  final SurveyDisplayMode surveyDisplayMode;

  /// Navigation functions
  final Function() previousStep;
  final Function() nextStep;
  final Function() nextStepEnding;

  /// Callback for capturing responses
  final Function(String, dynamic) onResponse;

  /// Current state of responses and required validation
  final Map<String, dynamic> responses;
  final Map<String, bool> requiredAnswers;

  /// Completion callback
  final VoidCallback? onComplete;

  /// Interaction and auto-close behavior
  final bool clickOutsideClose;
  final bool hasUserInteracted;
  final int inactivitySecondsRemaining;

  /// Optional custom question builders
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

  const SurveyForm({
    super.key,
    required this.client,
    required this.survey,
    required this.userId,
    this.customTheme,
    required this.currentStep,
    this.currentBlockIndex = 0,
    this.currentElementIndex = 0,
    required this.currentStepEnding,
    required this.isLoading,
    this.error,
    this.displayId,
    required this.estimatedTimeInSecs,
    required this.formKey,
    required this.nextStep,
    required this.nextStepEnding,
    required this.previousStep,
    required this.onResponse,
    required this.responses,
    required this.surveyDisplayMode,
    required this.requiredAnswers,
    required this.onComplete,
    required this.clickOutsideClose,
    required this.hasUserInteracted,
    required this.inactivitySecondsRemaining,
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildSurvey(context),
    );
  }

  /// Builds the main survey content based on the current step.
  Widget _buildSurvey(BuildContext context) {
    final bool useBlocks = survey.blocks != null && survey.blocks!.isNotEmpty;
    final allQuestions = useBlocks 
        ? (survey.blocks?.expand((b) => b.questions).toList() ?? []) 
        : (survey.questions ?? []);
    final totalSteps = allQuestions.length;

    Widget content;
    String? nextLabel;
    String? previousLabel;
    Question? question;

    /// Case: show welcome card
    if (currentStep == -1 && survey.welcomeCard?['enabled'] == true) {
      content = WelcomeWidget(survey: survey);
      nextLabel = survey.welcomeCard!['buttonLabel']?['default'] ?? 'Next';
    }
    /// Case: show current question
    else if (!useBlocks && currentStep < (survey.questions?.length ?? 0)) {
      question = survey.questions?[currentStep];
      if (question != null) {
        content = _buildQuestionWidget(question);
        nextLabel = question.buttonLabel?['default'];
        previousLabel = question.backButtonLabel?['default'];
      } else {
        content = Container();
      }
    }
    else if (useBlocks && currentBlockIndex < (survey.blocks?.length ?? 0)) {
      final block = survey.blocks?[currentBlockIndex];
      if (block != null && currentElementIndex < block.questions.length) {
        question = block.questions[currentElementIndex];
        content = _buildQuestionWidget(question);
        
        // Use block label if question label is null
        nextLabel = question.buttonLabel?['default'] ?? block.buttonLabel?['default'];
        previousLabel = question.backButtonLabel?['default'] ?? block.backButtonLabel?['default'];
      } else {
        content = Container(); // Should not happen
      }
    }
    /// Case: show ending or final screen
    else {
      if (survey.endings != null && survey.endings!.isNotEmpty) {
        final isLastEnding = currentStepEnding == (survey.endings!.length - 1);
        nextLabel = isLastEnding
            ? AppLocalizations.of(context)!.close
            : AppLocalizations.of(context)!.next;

        content = EndWidget(
          ending: survey.endings![currentStepEnding],
          showCloseButton: isLastEnding,
          onComplete: onComplete,
          nextLabel: nextLabel,
        );
      } else {
        nextLabel = AppLocalizations.of(context)!.close;
        content = CloseWidget(onComplete: onComplete);
      }
    }

    // Calculate progress index
    int progressIndex = currentStep;
    if (useBlocks) {
       progressIndex = 0;
       final blocks = survey.blocks ?? [];
       for (int i=0; i < currentBlockIndex && i < blocks.length; i++) {
         progressIndex += blocks[i].questions.length;
       }
       progressIndex += currentElementIndex;
    }

    /// Final assembled layout
    return SurveyContent(
      progress: (progressIndex + 1) / totalSteps,
      currentStep: currentStep,
      nextStep: nextStep,
      previousStep: previousStep,
      nextLabel: nextLabel,
      previousLabel: previousLabel,
      onResponse: onResponse,
      survey: survey,
      response: responses[question?.id],
      contentHeight: MediaQuery.of(context).size.height,
      spacerHeight: 0,
      surveyDisplayMode: surveyDisplayMode,
      estimatedTimeInSecs: estimatedTimeInSecs,
      onComplete: onComplete,
      clickOutsideClose: clickOutsideClose,
      hasUserInteracted: hasUserInteracted,
      inactivitySecondsRemaining: inactivitySecondsRemaining,
      child: content,
    );
  }

  Widget _buildQuestionWidget(Question question) {
     return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: QuestionWidget(
          question: question,
          onResponse: onResponse,
          client: client,
          surveyId: survey.id,
          userId: userId,
          response: responses[question.id],
          requiredAnswerByLogicCondition: requiredAnswers.containsKey(question.id),

          /// Custom question builders
          addressQuestionBuilder: addressQuestionBuilder,
          calQuestionBuilder: ctaQuestionBuilder,
          consentQuestionBuilder: consentQuestionBuilder,
          contactInfoQuestionBuilder: contactInfoQuestionBuilder,
          ctaQuestionBuilder: ctaQuestionBuilder,
          dateQuestionBuilder: dateQuestionBuilder,
          fileUploadQuestionBuilder: fileUploadQuestionBuilder,
          freeTextQuestionBuilder: freeTextQuestionBuilder,
          matrixQuestionBuilder: matrixQuestionBuilder,
          multipleChoiceMultiQuestionBuilder: multipleChoiceMultiQuestionBuilder,
          multipleChoiceSingleQuestionBuilder: multipleChoiceSingleQuestionBuilder,
          npsQuestionBuilder: npsQuestionBuilder,
          pictureSelectionQuestionBuilder: pictureSelectionQuestionBuilder,
          rankingQuestionBuilder: rankingQuestionBuilder,
          ratingQuestionBuilder: ratingQuestionBuilder,
        ),
      );
  }
}
