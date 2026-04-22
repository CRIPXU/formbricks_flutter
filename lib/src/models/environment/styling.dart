import 'package:json_annotation/json_annotation.dart';

part 'styling.g.dart';

@JsonSerializable()
class Styling {
  // Nested objects (for future-proofing/some versions)
  final CardStyling? card;
  final HeadlineStyling? headline;
  final InputStyling? input;
  final ButtonStyling? button;
  final OptionStyling? option;
  final ProgressStyling? progress;
  final BackgroundStyling? background;

  // Top-level flat fields (present in current RAW RESPONSE)
  final dynamic roundness;
  final bool? allowStyleOverwrite;
  final bool? overwriteThemeStyling;
  final bool? isLogoHidden;
  final bool? hideProgressBar;
  final bool? isDarkModeEnabled;
  final bool? inAppSurveyBranding;
  final String? logoUrl;

  final Map<String, dynamic>? brandColor;
  final Map<String, dynamic>? questionColor;
  final Map<String, dynamic>? cardBackgroundColor;
  final Map<String, dynamic>? cardBorderColor;
  final Map<String, dynamic>? cardShadowColor;
  final Map<String, dynamic>? highlightBorderColor;
  final Map<String, dynamic>? inputColor;
  final Map<String, dynamic>? inputBorderColor;
  final Map<String, dynamic>? inputTextColor;
  final Map<String, dynamic>? buttonBgColor;
  final Map<String, dynamic>? buttonTextColor;
  final Map<String, dynamic>? optionBgColor;
  final Map<String, dynamic>? optionLabelColor;
  final Map<String, dynamic>? optionBorderColor;
  final Map<String, dynamic>? progressTrackBgColor;
  final Map<String, dynamic>? progressIndicatorBgColor;
  final Map<String, dynamic>? elementHeadlineColor;
  final Map<String, dynamic>? elementDescriptionColor;
  final Map<String, dynamic>? elementUpperLabelColor;
  
  final dynamic inputBorderRadius;
  final dynamic inputHeight;
  final dynamic inputFontSize;
  final dynamic inputPaddingX;
  final dynamic inputPaddingY;
  final dynamic inputPlaceholderOpacity;
  final dynamic inputShadow;
  
  final dynamic buttonBorderRadius;
  final dynamic buttonHeight;
  final dynamic buttonFontSize;
  final dynamic buttonFontWeight;
  final dynamic buttonPaddingX;
  final dynamic buttonPaddingY;
  
  final dynamic optionBorderRadius;
  final dynamic optionFontSize;
  final dynamic optionPaddingX;
  final dynamic optionPaddingY;
  
  final dynamic progressTrackHeight;
  final dynamic elementHeadlineFontSize;
  final dynamic elementHeadlineFontWeight;
  final dynamic elementDescriptionFontSize;
  final dynamic elementDescriptionFontWeight;
  final dynamic elementUpperLabelFontSize;
  final dynamic elementUpperLabelFontWeight;
  
  final dynamic cardArrangement;

  Styling({
    this.card,
    this.headline,
    this.input,
    this.button,
    this.option,
    this.progress,
    this.background,
    this.roundness,
    this.allowStyleOverwrite,
    this.overwriteThemeStyling,
    this.isLogoHidden,
    this.hideProgressBar,
    this.isDarkModeEnabled,
    this.inAppSurveyBranding,
    this.logoUrl,
    this.brandColor,
    this.questionColor,
    this.cardBackgroundColor,
    this.cardBorderColor,
    this.cardShadowColor,
    this.highlightBorderColor,
    this.inputColor,
    this.inputBorderColor,
    this.inputTextColor,
    this.buttonBgColor,
    this.buttonTextColor,
    this.optionBgColor,
    this.optionLabelColor,
    this.optionBorderColor,
    this.progressTrackBgColor,
    this.progressIndicatorBgColor,
    this.elementHeadlineColor,
    this.elementDescriptionColor,
    this.elementUpperLabelColor,
    this.inputBorderRadius,
    this.inputHeight,
    this.inputFontSize,
    this.inputPaddingX,
    this.inputPaddingY,
    this.inputPlaceholderOpacity,
    this.inputShadow,
    this.buttonBorderRadius,
    this.buttonHeight,
    this.buttonFontSize,
    this.buttonFontWeight,
    this.buttonPaddingX,
    this.buttonPaddingY,
    this.optionBorderRadius,
    this.optionFontSize,
    this.optionPaddingX,
    this.optionPaddingY,
    this.progressTrackHeight,
    this.elementHeadlineFontSize,
    this.elementHeadlineFontWeight,
    this.elementDescriptionFontSize,
    this.elementDescriptionFontWeight,
    this.elementUpperLabelFontSize,
    this.elementUpperLabelFontWeight,
    this.cardArrangement,
  });

  factory Styling.fromJson(Map<String, dynamic> json) => _$StylingFromJson(json);
  Map<String, dynamic> toJson() => _$StylingToJson(this);
}

@JsonSerializable()
class CardStyling {
  final dynamic roundness;
  final Map<String, dynamic>? backgroundColor;
  final Map<String, dynamic>? borderColor;
  final Map<String, dynamic>? highlightBorderColor;
  final String? arrangement; 
  final Map<String, dynamic>? overlay;
  final String? placement; 
  final bool? clickOutsideClose;

  CardStyling({this.roundness, this.backgroundColor, this.borderColor, this.highlightBorderColor, this.arrangement, this.overlay, this.placement, this.clickOutsideClose});
  factory CardStyling.fromJson(Map<String, dynamic> json) => _$CardStylingFromJson(json);
  Map<String, dynamic> toJson() => _$CardStylingToJson(this);
}

@JsonSerializable()
class HeadlineStyling {
  final Map<String, dynamic>? color;
  final dynamic fontSize;
  final dynamic fontWeight;
  final Map<String, dynamic>? descriptionColor;
  final dynamic descriptionFontSize;
  final dynamic descriptionFontWeight;
  final Map<String, dynamic>? upperLabelColor;
  final dynamic upperLabelFontSize;
  final dynamic upperLabelFontWeight;

  HeadlineStyling({this.color, this.fontSize, this.fontWeight, this.descriptionColor, this.descriptionFontSize, this.descriptionFontWeight, this.upperLabelColor, this.upperLabelFontSize, this.upperLabelFontWeight});
  factory HeadlineStyling.fromJson(Map<String, dynamic> json) => _$HeadlineStylingFromJson(json);
  Map<String, dynamic> toJson() => _$HeadlineStylingToJson(this);
}

@JsonSerializable()
class InputStyling {
  @JsonKey(name: 'backgroundColor')
  final Map<String, dynamic>? backgroundColor;
  @JsonKey(name: 'borderColor')
  final Map<String, dynamic>? borderColor;
  @JsonKey(name: 'textColor')
  final Map<String, dynamic>? textColor;
  @JsonKey(name: 'borderRadius')
  final dynamic borderRadius;
  @JsonKey(name: 'height')
  final dynamic height;
  @JsonKey(name: 'fontSize')
  final dynamic fontSize;
  @JsonKey(name: 'paddingX')
  final dynamic paddingX;
  @JsonKey(name: 'paddingY')
  final dynamic paddingY;
  @JsonKey(name: 'placeholderOpacity')
  final dynamic placeholderOpacity;
  @JsonKey(name: 'shadow')
  final Map<String, dynamic>? shadow;

  InputStyling({this.backgroundColor, this.borderColor, this.textColor, this.borderRadius, this.height, this.fontSize, this.paddingX, this.paddingY, this.placeholderOpacity, this.shadow});
  factory InputStyling.fromJson(Map<String, dynamic> json) => _$InputStylingFromJson(json);
  Map<String, dynamic> toJson() => _$InputStylingToJson(this);
}

@JsonSerializable()
class ButtonStyling {
  @JsonKey(name: 'backgroundColor')
  final Map<String, dynamic>? backgroundColor;
  @JsonKey(name: 'textColor')
  final Map<String, dynamic>? textColor;
  @JsonKey(name: 'borderRadius')
  final dynamic borderRadius;
  @JsonKey(name: 'height')
  final dynamic height;
  @JsonKey(name: 'fontSize')
  final dynamic fontSize;
  @JsonKey(name: 'fontWeight')
  final dynamic fontWeight;
  @JsonKey(name: 'paddingX')
  final dynamic paddingX;
  @JsonKey(name: 'paddingY')
  final dynamic paddingY;

  ButtonStyling({this.backgroundColor, this.textColor, this.borderRadius, this.height, this.fontSize, this.fontWeight, this.paddingX, this.paddingY});
  factory ButtonStyling.fromJson(Map<String, dynamic> json) => _$ButtonStylingFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonStylingToJson(this);
}

@JsonSerializable()
class OptionStyling {
  final Map<String, dynamic>? backgroundColor;
  final Map<String, dynamic>? labelColor;
  final dynamic borderRadius;
  final dynamic paddingX;
  final dynamic paddingY;
  final dynamic fontSize;
  final Map<String, dynamic>? borderColor;

  OptionStyling({this.backgroundColor, this.labelColor, this.borderRadius, this.paddingX, this.paddingY, this.fontSize, this.borderColor});
  factory OptionStyling.fromJson(Map<String, dynamic> json) => _$OptionStylingFromJson(json);
  Map<String, dynamic> toJson() => _$OptionStylingToJson(this);
}

@JsonSerializable()
class ProgressStyling {
  final Map<String, dynamic>? trackBackgroundColor;
  final Map<String, dynamic>? indicatorBackgroundColor;
  final dynamic trackHeight;

  ProgressStyling({this.trackBackgroundColor, this.indicatorBackgroundColor, this.trackHeight});
  factory ProgressStyling.fromJson(Map<String, dynamic> json) => _$ProgressStylingFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressStylingToJson(this);
}

@JsonSerializable()
class BackgroundStyling {
  final dynamic bg;
  final String? bgType; 
  final dynamic brightness; 
  final Map<String, dynamic>? logo; 

  BackgroundStyling({this.bg, this.bgType, this.brightness, this.logo});
  factory BackgroundStyling.fromJson(Map<String, dynamic> json) => _$BackgroundStylingFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundStylingToJson(this);
}