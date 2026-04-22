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

  Color themedColor(Map<String, dynamic>? colorMap, {required Color fallback}) {
    if (colorMap == null) return fallback;
    return parseColor(
      isDarkMode && colorMap.containsKey('dark') ? colorMap['dark'] : colorMap['light'],
      fallback: fallback,
    );
  }

  // --- 1. Card & Global ---
  final cardStyling = formBricksStyling.card;
  final globalRoundness = cardStyling?.roundness ?? formBricksStyling.roundness ?? 8.0;
  final cardBgColor = themedColor(cardStyling?.backgroundColor ?? formBricksStyling.cardBackgroundColor, fallback: baseTheme.cardColor);
  final cardBorderColor = themedColor(cardStyling?.borderColor ?? formBricksStyling.cardBorderColor, fallback: Colors.transparent);
  final highlightColor = themedColor(cardStyling?.highlightBorderColor ?? formBricksStyling.highlightBorderColor, fallback: Colors.blueAccent);

  // --- 2. Headline ---
  final headlineStyling = formBricksStyling.headline;
  final headlineColor = themedColor(headlineStyling?.color ?? formBricksStyling.questionColor, fallback: baseTheme.textTheme.headlineMedium?.color ?? Colors.black);
  final descColor = themedColor(headlineStyling?.descriptionColor, fallback: (baseTheme.textTheme.bodyMedium?.color ?? Colors.black).withOpacity(0.7));

  // --- 3. Buttons ---
  final buttonStyling = formBricksStyling.button;
  final btnBgColor = themedColor(buttonStyling?.backgroundColor ?? formBricksStyling.brandColor, fallback: baseTheme.primaryColor);
  final btnTextColor = themedColor(buttonStyling?.textColor, fallback: Colors.white);
  final btnRadius = (buttonStyling?.borderRadius ?? globalRoundness).toDouble();

  // --- 4. Inputs ---
  final inputStyling = formBricksStyling.input;
  final inputBgColor = themedColor(inputStyling?.backgroundColor ?? formBricksStyling.inputColor, fallback: baseTheme.inputDecorationTheme.fillColor ?? Colors.grey[100]!);
  final inputBorderColor = themedColor(inputStyling?.borderColor ?? formBricksStyling.inputBorderColor, fallback: Colors.grey);
  final inputTextColor = themedColor(inputStyling?.textColor, fallback: baseTheme.textTheme.bodyMedium?.color ?? Colors.black);
  final inputRadius = (inputStyling?.borderRadius ?? globalRoundness).toDouble();

  // --- 5. Progress ---
  final progressStyling = formBricksStyling.progress;
  final progressTrackColor = themedColor(progressStyling?.trackBackgroundColor, fallback: Colors.grey[300]!);
  final progressIndicatorColor = themedColor(progressStyling?.indicatorBackgroundColor ?? formBricksStyling.brandColor, fallback: btnBgColor);

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
        minimumSize: Size(0, (buttonStyling?.height ?? 40).toDouble()),
        textStyle: TextStyle(
          fontSize: (buttonStyling?.fontSize ?? 16).toDouble(),
          fontWeight: buttonStyling?.fontWeight == 'bold' ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(btnRadius),
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: (buttonStyling?.paddingX ?? 24).toDouble(),
          vertical: (buttonStyling?.paddingY ?? 12).toDouble(),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBgColor,
      labelStyle: TextStyle(color: inputTextColor, fontSize: (inputStyling?.fontSize ?? 14).toDouble()),
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
        fontSize: (headlineStyling?.fontSize ?? 18).toDouble(),
        fontWeight: headlineStyling?.fontWeight == 'bold' ? FontWeight.bold : FontWeight.normal,
      ),
      bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
        color: descColor,
        fontSize: (headlineStyling?.descriptionFontSize ?? 14).toDouble(),
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
  final ProgressStyling? progressStyling;
  final CardStyling? cardStyling;
  final bool isDarkMode;

  const MyCustomTheme({
    this.styleRoundness,
    this.optionStyling,
    this.progressStyling,
    this.cardStyling,
    this.isDarkMode = false,
  });

  @override
  MyCustomTheme copyWith({
    double? styleRoundness,
    OptionStyling? optionStyling,
    ProgressStyling? progressStyling,
    CardStyling? cardStyling,
    bool? isDarkMode,
  }) {
    return MyCustomTheme(
      styleRoundness: styleRoundness ?? this.styleRoundness,
      optionStyling: optionStyling ?? this.optionStyling,
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
      progressStyling: other.progressStyling,
      cardStyling: other.cardStyling,
      isDarkMode: other.isDarkMode,
    );
  }
}
