import 'package:flutter/material.dart';
import '../../../../formbricks_flutter.dart';

class SurveyButtons extends StatelessWidget {
  final int currentStep;
  final String? nextLabel;
  final String? previousLabel;
  final Survey survey;
  final Function() previousStep;
  final Function() nextStep;
  final VoidCallback? onComplete;
  final QuestionType? currentQuestionType;

  const SurveyButtons({
    super.key,
    required this.currentStep,
    required this.nextStep,
    required this.previousStep,
    required this.nextLabel,
    required this.previousLabel,
    required this.survey,
    required this.onComplete,
    this.currentQuestionType,
  });

  @override
  Widget build(BuildContext context) {
    final bool useBlocks = survey.blocks != null && survey.blocks!.isNotEmpty;
    final int totalQuestions = useBlocks
        ? survey.blocks!.fold(0, (sum, b) => sum + b.questions.length)
        : (survey.questions?.length ?? 0);

    return currentStep < totalQuestions
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: currentStep >= totalQuestions
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (currentStep > 0 &&
                    survey.isBackButtonHidden == false)
                  OutlinedButton(
                    onPressed: previousStep,
                    child: Text(
                      previousLabel ?? AppLocalizations.of(context)!.back,
                    ),
                  ),
                if (currentStep > 0 && survey.isBackButtonHidden == true)
                  SizedBox.shrink(),

                if (nextLabel != null)
                  if (currentStep == -1 ||
                      (currentStep > -1 &&
                          ![QuestionType.rating, QuestionType.nps].contains(
                            currentQuestionType,
                          )))
                    ElevatedButton(
                      onPressed: currentStep >= totalQuestions
                          ? () {
                              onComplete
                                  ?.call(); // notify TriggerManager to show next
                              Navigator.of(context).pop();
                            }
                          : nextStep,
                      child: Text(
                        nextLabel ?? AppLocalizations.of(context)!.next,
                      ),
                    ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
