import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../formbricks_flutter.dart';
import '../../../utils/helper.dart';
import '../../../utils/theme_manager.dart';
import '../components/custom_heading.dart';
import '../survey_widget.dart';

class RatingQuestion extends StatefulWidget {
  final Question question;
  final Function(String, dynamic) onResponse;
  final dynamic response;
  final bool requiredAnswerByLogicCondition;

  const RatingQuestion({
    super.key,
    required this.question,
    required this.onResponse,
    this.response,
    required this.requiredAnswerByLogicCondition,
  });

  @override
  State<RatingQuestion> createState() => _RatingQuestionState();
}

class _RatingQuestionState extends State<RatingQuestion> {
  double? selectedRating;

  @override
  void initState() {
    super.initState();
    selectedRating = (widget.response as int?)?.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final range =
        int.tryParse(widget.question.range?.toString() ?? '5') ??
        5; //3,4,6,7,10
    final scale = widget.question.scale ?? 'star'; // 'star', 'smiley', 'number'
    bool isRequired = widget.question.required ?? false;
    if (widget.requiredAnswerByLogicCondition) {
      isRequired = widget.requiredAnswerByLogicCondition;
    }

    IconData getSmileyIcon(int index, int range) {
      final smileys = [
        LineAwesomeIcons.sad_cry, // 1 - Very sad
        LineAwesomeIcons.sad_tear, // 2 - Sad
        LineAwesomeIcons.frown, // 3 - Disappointed
        LineAwesomeIcons.frown_open, // 4 - Unhappy
        LineAwesomeIcons.meh, // 5 - Neutral
        LineAwesomeIcons.smile, // 6 - Slightly positive
        LineAwesomeIcons.grin, // 7 - Happy
        LineAwesomeIcons.grin_alt, // 8 - Very happy
        LineAwesomeIcons.grin_squint, // 9 - Excited
        LineAwesomeIcons.grin_tears, // 10 - Extremely happy
      ];
      // Map current index to smiley range
      double normalized = index / (range - 1); // between 0.0 and 1.0
      int smileyIndex = (normalized * (smileys.length - 1)).round();

      return smileys[smileyIndex.clamp(0, smileys.length - 1)];
    }

    Widget buildRatingWidget(FormFieldState<double> field) {
      final customTheme = theme.extension<MyCustomTheme>();
      final optionStyling = customTheme?.optionStyling;
      final isDarkMode = customTheme?.isDarkMode ?? false;

      Color themedColor(Map<String, dynamic>? colorMap, {required Color fallback}) {
        if (colorMap == null) return fallback;
        final hex = isDarkMode && colorMap.containsKey('dark') ? colorMap['dark'] : colorMap['light'];
        if (hex == null || hex.isEmpty) return fallback;
        String h = hex.replaceFirst('#', '');
        if (h.length == 6) h = 'FF$h';
        return Color(int.tryParse('0x$h') ?? fallback.toARGB32());
      }

      if (scale == 'number') {
        final optBgColor = themedColor(optionStyling?.backgroundColor, fallback: Colors.white);
        final optLabelColor = themedColor(optionStyling?.labelColor, fallback: theme.primaryColor);
        final optBorderColor = themedColor(optionStyling?.borderColor, fallback: theme.primaryColor);
        final optRadius = (optionStyling?.borderRadius ?? customTheme?.styleRoundness ?? 8.0).toDouble();

        return Wrap(
          spacing: (optionStyling?.paddingX ?? 8).toDouble(),
          runSpacing: (optionStyling?.paddingY ?? 8).toDouble(),
          children: List.generate(range, (index) {
            final value = index + 1;
            final isSelected = selectedRating == value.toDouble();
            return GestureDetector(
              onTap: () {
                setState(() => selectedRating = value.toDouble());
                field.didChange(selectedRating);
                widget.onResponse(widget.question.id, value);

                final formState = context
                    .findAncestorStateOfType<SurveyWidgetState>()
                    ?.formKey
                    .currentState;
                if (formState?.validate() ?? false) {
                  context
                      .findAncestorStateOfType<SurveyWidgetState>()
                      ?.nextStep();
                }
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(optRadius),
                  border: Border.all(color: isSelected ? theme.primaryColor : optBorderColor),
                  color: isSelected ? theme.primaryColor : optBgColor,
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : optLabelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: (optionStyling?.fontSize ?? 16).toDouble(),
                  ),
                ),
              ),
            );
          }),
        );
      }

      return PannableRatingBar(
        rate: selectedRating ?? 0,
        maxRating: range.toDouble(),
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        spacing: 1,
        minRating: 0,
        items: List.generate(range, (index) {
          Color getSmileyColor(int index, int range) {
            final ratio = index / (range - 1);
            if (ratio < 0.4) {
              return const Color(0xFF8B0000); // Pitch/Dark Red
            } else if (ratio < 0.6) {
              return Colors.grey.shade600;
            } else {
              return Colors.amberAccent.shade700;
            }
          }

          if (scale == 'smiley') {
            return RatingWidget(
              selectedColor: theme.primaryColor,
              unSelectedColor: getSmileyColor(index, range),
              child: Icon(
                getSmileyIcon(index, range),
                size: range > 6
                    ? range == 7
                          ? 32
                          : 28
                    : 40,
              ),
            );
          }
          return RatingWidget(
            selectedColor: theme.primaryColor,
            unSelectedColor: Colors.grey,
            child: Icon(Icons.star, size: 40),
          );
        }),
        onChanged: (rating) {
          setState(() => selectedRating = rating);
          field.didChange(rating);
          widget.onResponse(widget.question.id, rating.toInt());

          final formState = context
              .findAncestorStateOfType<SurveyWidgetState>()
              ?.formKey
              .currentState;
          if (formState?.validate() ?? false) {
            context.findAncestorStateOfType<SurveyWidgetState>()?.nextStep();
          }
        },
      );
    }

    return FormField<double>(
      key: ValueKey(widget.question.id),
      validator: (value) =>
          isRequired && (selectedRating == null || selectedRating == 0)
          ? AppLocalizations.of(context)!.please_select_rating
          : null,
      builder: (FormFieldState<double> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomHeading(question: widget.question, required: isRequired),
            buildRatingWidget(field),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.question.lowerLabel != null)
                  Text(
                    translate(widget.question.lowerLabel, context) ?? '',
                    style: theme.textTheme.bodySmall,
                  ),
                if (widget.question.upperLabel != null)
                  Text(
                    translate(widget.question.upperLabel, context) ?? '',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
