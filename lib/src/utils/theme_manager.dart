import 'dart:ui';
import 'package:flutter/material.dart';
import '../../formbricks_flutter.dart';

/// Builds a custom [ThemeData] for Formbricks surveys based on comprehensive 4.7+ styling.
ThemeData buildTheme(BuildContext context, ThemeData? customTheme, Survey survey) {
  final parentTheme = Theme.of(context);
  final baseTheme = customTheme ?? parentTheme;
  final formBricksStyling = survey.styling;

  if (!(formBricksStyling != null && (formBricksStyling.overwriteThemeStyling == true || formBricksStyling.allowStyleOverwrite == true))) {
    return baseTheme;
  }

  final brightness = baseTheme.brightness;
  final isDarkMode = brightness == Brightness.dark || formBricksStyling.isDarkModeEnabled == true;

  Color parseColor(String? hex, {required Color fallback}) {
    if (hex == null || hex.isEmpty) return fallback;
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.tryParse('0x$hex') ?? fallback.toARGB32());
  }

  double toDoubleSafe(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value == 'auto') return fallback;
      return double.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  Color themedColor(Map<String, dynamic>? colorMap, {required Color fallback}) {
    if (colorMap == null) return fallback;
    return parseColor(
      isDarkMode && colorMap.containsKey('dark') ? colorMap['dark'] : colorMap['light'],
      fallback: fallback,
    );
  }

  // --- 1. Card & Global ---
  final cardStyling = formBricksStyling.card;
  final globalRoundness = toDoubleSafe(cardStyling?.roundness ?? formBricksStyling.roundness, fallback: 8.0);
  final cardBgColor = themedColor(cardStyling?.backgroundColor ?? formBricksStyling.cardBackgroundColor, fallback: baseTheme.cardColor);
  final cardBorderColor = themedColor(cardStyling?.borderColor ?? formBricksStyling.cardBorderColor, fallback: Colors.transparent);
  final highlightColor = themedColor(cardStyling?.highlightBorderColor ?? formBricksStyling.highlightBorderColor, fallback: Colors.blueAccent);

  // --- 2. Headline ---
  final headlineStyling = formBricksStyling.headline;
  final headlineColor = themedColor(headlineStyling?.color ?? formBricksStyling.elementHeadlineColor, fallback: baseTheme.textTheme.headlineMedium?.color ?? Colors.black);
  final descColor = themedColor(headlineStyling?.descriptionColor ?? formBricksStyling.elementDescriptionColor, fallback: (baseTheme.textTheme.bodyMedium?.color ?? Colors.black).withOpacity(0.7));

  // --- 3. Buttons ---
  final buttonStyling = formBricksStyling.button;
  final btnBgColor = themedColor(buttonStyling?.backgroundColor ?? formBricksStyling.buttonBgColor, fallback: baseTheme.primaryColor);
  final btnTextColor = themedColor(buttonStyling?.textColor ?? formBricksStyling.buttonTextColor, fallback: Colors.white);
  final btnRadius = toDoubleSafe(buttonStyling?.borderRadius ?? formBricksStyling.buttonBorderRadius, fallback: globalRoundness);

  // --- 4. Inputs ---
  final inputStyling = formBricksStyling.input;
  final inputBgColor = themedColor(inputStyling?.backgroundColor ?? formBricksStyling.inputColor, fallback: baseTheme.inputDecorationTheme.fillColor ?? Colors.grey[100]!);
  final inputBorderColor = themedColor(inputStyling?.borderColor ?? formBricksStyling.inputBorderColor, fallback: Colors.grey);
  final inputTextColor = themedColor(inputStyling?.textColor ?? formBricksStyling.inputTextColor, fallback: baseTheme.textTheme.bodyMedium?.color ?? Colors.black);
  final inputRadius = toDoubleSafe(inputStyling?.borderRadius ?? formBricksStyling.inputBorderRadius, fallback: globalRoundness);

  // --- 5. Progress ---
  final progressStyling = formBricksStyling.progress;
  final progressTrackColor = themedColor(progressStyling?.trackBackgroundColor ?? formBricksStyling.progressTrackBgColor, fallback: Colors.grey[300]!);
  final progressIndicatorColor = themedColor(progressStyling?.indicatorBackgroundColor ?? formBricksStyling.progressIndicatorBgColor ?? formBricksStyling.brandColor, fallback: btnBgColor);

  return baseTheme.copyWith(
    primaryColor: btnBgColor,
    scaffoldBackgroundColor: cardBgColor,
    cardColor: cardBgColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    
    cardTheme: baseTheme.cardTheme.copyWith(
      color: cardBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(globalRoundness),
        side: BorderSide(color: cardBorderColor),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBgColor,
        foregroundColor: btnTextColor,
        minimumSize: Size(0, toDoubleSafe(buttonStyling?.height ?? formBricksStyling.buttonHeight, fallback: 40.0)),
        textStyle: TextStyle(
          fontSize: toDoubleSafe(buttonStyling?.fontSize ?? formBricksStyling.buttonFontSize, fallback: 16.0),
          fontWeight: (buttonStyling?.fontWeight ?? formBricksStyling.buttonFontWeight) == 'bold' ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(btnRadius),
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: toDoubleSafe(buttonStyling?.paddingX ?? formBricksStyling.buttonPaddingX, fallback: 24.0),
          vertical: toDoubleSafe(buttonStyling?.paddingY ?? formBricksStyling.buttonPaddingY, fallback: 12.0),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBgColor,
      labelStyle: TextStyle(color: inputTextColor, fontSize: toDoubleSafe(inputStyling?.fontSize ?? formBricksStyling.inputFontSize, fallback: 14.0)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(color: inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(color: inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(color: highlightColor, width: 2),
      ),
    ),

    textTheme: baseTheme.textTheme.copyWith(
      headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
        color: headlineColor,
        fontSize: toDoubleSafe(headlineStyling?.fontSize ?? formBricksStyling.elementHeadlineFontSize, fallback: 18.0),
        fontWeight: (headlineStyling?.fontWeight ?? formBricksStyling.elementHeadlineFontWeight) == 'bold' ? FontWeight.bold : FontWeight.normal,
      ),
      bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
        color: descColor,
        fontSize: toDoubleSafe(headlineStyling?.descriptionFontSize ?? formBricksStyling.elementDescriptionFontSize, fallback: 14.0),
      ),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: progressIndicatorColor,
      linearTrackColor: progressTrackColor,
    ),

    extensions: <ThemeExtension<dynamic>>[
      MyCustomTheme(
        styleRoundness: globalRoundness,
        optionStyling: formBricksStyling.option,
        headlineStyling: headlineStyling,
        inputStyling: inputStyling,
        progressStyling: progressStyling,
        cardStyling: cardStyling,
        isDarkMode: isDarkMode,
      ),
    ],
  );
}

@immutable
class MyCustomTheme extends ThemeExtension<MyCustomTheme> {
  final double? styleRoundness;
  final OptionStyling? optionStyling;
  final HeadlineStyling? headlineStyling;
  final InputStyling? inputStyling;
  final ProgressStyling? progressStyling;
  final CardStyling? cardStyling;
  final bool isDarkMode;

  const MyCustomTheme({
    this.styleRoundness,
    this.optionStyling,
    this.headlineStyling,
    this.inputStyling,
    this.progressStyling,
    this.cardStyling,
    this.isDarkMode = false,
  });

  @override
  MyCustomTheme copyWith({
    double? styleRoundness,
    OptionStyling? optionStyling,
    HeadlineStyling? headlineStyling,
    InputStyling? inputStyling,
    ProgressStyling? progressStyling,
    CardStyling? cardStyling,
    bool? isDarkMode,
  }) {
    return MyCustomTheme(
      styleRoundness: styleRoundness ?? this.styleRoundness,
      optionStyling: optionStyling ?? this.optionStyling,
      headlineStyling: headlineStyling ?? this.headlineStyling,
      inputStyling: inputStyling ?? this.inputStyling,
      progressStyling: progressStyling ?? this.progressStyling,
      cardStyling: cardStyling ?? this.cardStyling,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  MyCustomTheme lerp(ThemeExtension<MyCustomTheme>? other, double t) {
    if (other is! MyCustomTheme) return this;
    return MyCustomTheme(
      styleRoundness: lerpDouble(styleRoundness, other.styleRoundness, t),
      optionStyling: other.optionStyling,
      headlineStyling: other.headlineStyling,
      inputStyling: other.inputStyling,
      progressStyling: other.progressStyling,
      cardStyling: other.cardStyling,
      isDarkMode: other.isDarkMode,
    );
  }
}
