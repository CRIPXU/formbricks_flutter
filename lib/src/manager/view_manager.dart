import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../formbricks_flutter.dart';
import '../survey/in_app/survey_widget.dart';
import '../survey/webview/survey_webview.dart';
import '../utils/helper.dart';
import '../utils/theme_manager.dart';

/// Handles how surveys are presented in the app – full screen, dialog, bottom sheet, or web view.
class ViewManager {
  /// Displays the Flutter-based survey UI using the specified display mode.
  static void showSurveyInApp(
      BuildContext context,
      FormbricksClient client,
      String userId,
      Survey survey,
      SurveyDisplayMode surveyDisplayMode,
      int estimatedTimeInSecs, {
        FormbricksInAppConfig? formbricksInAppConfig,
      }) {

    /// Build the actual survey widget using registered question builders.
    final widgetBody = _buildSurveyWidget(
      client,
      userId,
      survey,
      estimatedTimeInSecs,
      surveyDisplayMode,
      survey.projectOverwrites?['clickOutsideClose'] ?? false,
      customTheme: formbricksInAppConfig?.customTheme,
      addressQuestionBuilder: formbricksInAppConfig?.addressQuestionBuilder,
      calQuestionBuilder: formbricksInAppConfig?.calQuestionBuilder,
      consentQuestionBuilder: formbricksInAppConfig?.consentQuestionBuilder,
      contactInfoQuestionBuilder:
      formbricksInAppConfig?.contactInfoQuestionBuilder,
      ctaQuestionBuilder: formbricksInAppConfig?.ctaQuestionBuilder,
      dateQuestionBuilder: formbricksInAppConfig?.dateQuestionBuilder,
      fileUploadQuestionBuilder:
      formbricksInAppConfig?.fileUploadQuestionBuilder,
      freeTextQuestionBuilder: formbricksInAppConfig?.freeTextQuestionBuilder,
      matrixQuestionBuilder: formbricksInAppConfig?.matrixQuestionBuilder,
      multipleChoiceMultiQuestionBuilder:
      formbricksInAppConfig?.multipleChoiceMultiQuestionBuilder,
      multipleChoiceSingleQuestionBuilder:
      formbricksInAppConfig?.multipleChoiceSingleQuestionBuilder,
      npsQuestionBuilder: formbricksInAppConfig?.npsQuestionBuilder,
      pictureSelectionQuestionBuilder:
      formbricksInAppConfig?.pictureSelectionQuestionBuilder,
      rankingQuestionBuilder: formbricksInAppConfig?.rankingQuestionBuilder,
      ratingQuestionBuilder: formbricksInAppConfig?.ratingQuestionBuilder,
    );

    /// Determine display mode and placement from survey config
    final String surveyType = survey.type; // popover, modal, fullScreen
    final String placement = survey.projectOverwrites?['placement'] ?? 'bottomRight';

    Alignment alignment = Alignment.center;
    if (surveyType == 'popover') {
      switch (placement) {
        case 'bottomRight':
          alignment = Alignment.bottomRight;
          break;
        case 'bottomLeft':
          alignment = Alignment.bottomLeft;
          break;
        case 'topRight':
          alignment = Alignment.topRight;
          break;
        case 'topLeft':
          alignment = Alignment.topLeft;
          break;
        case 'center':
          alignment = Alignment.center;
          break;
        default:
          alignment = Alignment.bottomRight;
      }
    }

    /// Determine which mode to actually use
    SurveyDisplayMode effectiveMode = surveyDisplayMode;
    if (surveyType == 'fullScreen') {
      effectiveMode = SurveyDisplayMode.fullScreen;
    } else if (surveyType == 'popover' || surveyType == 'modal') {
      effectiveMode = SurveyDisplayMode.dialog;
    }

    /// Render survey as full screen page.
    if (effectiveMode == SurveyDisplayMode.fullScreen) {
      final widget = Theme(
        data: buildTheme(context, formbricksInAppConfig?.customTheme, survey),
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: AppBar(
            automaticallyImplyLeading: false, // 👈 Hides the back button
          ),
          body: widgetBody,
        ),
      );
      Navigator.push(
        context,
        Platform.isIOS
            ? CupertinoPageRoute(builder: (context) => widget)
            : MaterialPageRoute(builder: (context) => widget),
      );
    }
    /// Render survey as an alert dialog with positioning.
    else if (effectiveMode == SurveyDisplayMode.dialog) {
      final themeData = buildTheme(context, formbricksInAppConfig?.customTheme, survey);
      showGeneralDialog(
        context: context,
        barrierDismissible: survey.projectOverwrites?['clickOutsideClose'] ?? false,
        barrierLabel: 'Survey',
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                color: Colors.transparent,
                child: Theme(
                  data: themeData,
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeData.cardColor,
                      borderRadius: BorderRadius.circular(themeData.extension<MyCustomTheme>()?.styleRoundness ?? 8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: widgetBody,
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: child,
          );
        },
      );
    }
    /// Render survey as a modal bottom sheet.
    else {
      final widget = Theme(
        data: buildTheme(context, formbricksInAppConfig?.customTheme, survey),
        child: widgetBody,
      );
      showModalBottomSheet(
        context: context,
        isDismissible: survey.projectOverwrites?['clickOutsideClose'] ?? false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: widget,
        ),
      );
    }
  }

  /// Displays a web-based version of the survey in a full-screen draggable bottom sheet.
  static void showSurveyWeb(
      BuildContext context,
      FormbricksClient client,
      String userId,
      Survey survey,
      String language,
      String platform,
      Map<String, dynamic> environmentData,
      ) {
    final widget = Container(
      color: Colors.transparent,
      child: SurveyWebview(
        client: client,
        survey: survey,
        userId: userId,
        language: language,
        environmentData: environmentData,
        platform: platform,
        onComplete: () {},
      ),
    );

    showModalBottomSheet(
      context: context,
      isDismissible: survey.projectOverwrites?['clickOutsideClose'] ?? false,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.6,
        maxChildSize: 1.0,
        builder: (context, scrollController) => widget,
      ),
    );
  }

  /// Internal method to create the main `SurveyWidget` using custom question builders.
  static SurveyWidget _buildSurveyWidget(
      FormbricksClient client,
      String userId,
      Survey survey,
      int estimatedTimeInSecs,
      SurveyDisplayMode surveyDisplayMode,
      bool clickOutsideClose, {
        ThemeData? customTheme,
        QuestionWidgetBuilder? addressQuestionBuilder,
        QuestionWidgetBuilder? calQuestionBuilder,
        QuestionWidgetBuilder? consentQuestionBuilder,
        QuestionWidgetBuilder? contactInfoQuestionBuilder,
        QuestionWidgetBuilder? ctaQuestionBuilder,
        QuestionWidgetBuilder? dateQuestionBuilder,
        QuestionWidgetBuilder? fileUploadQuestionBuilder,
        QuestionWidgetBuilder? freeTextQuestionBuilder,
        QuestionWidgetBuilder? matrixQuestionBuilder,
        QuestionWidgetBuilder? multipleChoiceMultiQuestionBuilder,
        QuestionWidgetBuilder? multipleChoiceSingleQuestionBuilder,
        QuestionWidgetBuilder? npsQuestionBuilder,
        QuestionWidgetBuilder? pictureSelectionQuestionBuilder,
        QuestionWidgetBuilder? rankingQuestionBuilder,
        QuestionWidgetBuilder? ratingQuestionBuilder,
      }) {
    return SurveyWidget(
      client: client,
      survey: survey,
      userId: userId,
      surveyDisplayMode: surveyDisplayMode,
      estimatedTimeInSecs: estimatedTimeInSecs,
      clickOutsideClose: clickOutsideClose,
      customTheme: customTheme,
      addressQuestionBuilder: addressQuestionBuilder,
      calQuestionBuilder: calQuestionBuilder,
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
      onComplete: () {}, // Placeholder for future callback
    );
  }
}
