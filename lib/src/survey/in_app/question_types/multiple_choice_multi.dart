import 'package:flutter/material.dart';
import '../../../../formbricks_flutter.dart';
import '../../../utils/helper.dart';
import '../../../utils/theme_manager.dart';
import '../components/custom_heading.dart';

class MultipleChoiceMultiQuestion extends StatefulWidget {
  final Question question;
  final Function(String, dynamic) onResponse;
  final dynamic response;
  final bool requiredAnswerByLogicCondition;

  const MultipleChoiceMultiQuestion({
    super.key,
    required this.question,
    required this.onResponse,
    this.response,
    required this.requiredAnswerByLogicCondition
  });

  @override
  State<MultipleChoiceMultiQuestion> createState() => _MultipleChoiceMultiQuestionState();
}

class _MultipleChoiceMultiQuestionState extends State<MultipleChoiceMultiQuestion> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.response as List<String>? ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = widget.question.choices ?? [];
    bool isRequired = widget.question.required ?? false;
    if(widget.requiredAnswerByLogicCondition){
      isRequired = widget.requiredAnswerByLogicCondition;
    }

    return FormField<bool>(
      key: ValueKey(widget.question.id),
      validator: (value) => isRequired && selectedOptions.isEmpty
          ? AppLocalizations.of(context)!.please_select_option
          : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeading(question: widget.question, required: isRequired),
            ...options.map((option) {
              final optionId = option['id']?.toString();
              final label = translate(option['label'], context)?.toString() ?? '';
              final isSelected = selectedOptions.contains(label);

              if (optionId == null) return const SizedBox.shrink();

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

              final optBgColor = themedColor(optionStyling?.backgroundColor, fallback: theme.inputDecorationTheme.fillColor ?? Colors.grey[100]!);
              final optLabelColor = themedColor(optionStyling?.labelColor, fallback: theme.textTheme.bodyMedium?.color ?? Colors.black);
              final optBorderColor = themedColor(optionStyling?.borderColor, fallback: theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey);
              final optRadius = (optionStyling?.borderRadius ?? customTheme?.styleRoundness ?? 8.0).toDouble();

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedOptions.remove(label);
                    } else {
                      selectedOptions.add(label);
                    }
                    widget.onResponse(widget.question.id, selectedOptions);
                    field.didChange(true);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(
                    horizontal: (optionStyling?.paddingX ?? 12).toDouble(),
                    vertical: (optionStyling?.paddingY ?? 14).toDouble(),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? theme.primaryColor : optBorderColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(optRadius),
                    color: isSelected ? theme.primaryColor.withOpacity(0.1) : optBgColor,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected
                            ? theme.primaryColor
                            : theme.unselectedWidgetColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected ? theme.primaryColor : optLabelColor,
                            fontSize: (optionStyling?.fontSize ?? 16).toDouble(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
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
