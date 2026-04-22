import 'package:json_annotation/json_annotation.dart';

part 'styling.g.dart';

@JsonSerializable()
class Styling {
  final CardStyling? card;
  final HeadlineStyling? headline;
  final InputStyling? input;
  final ButtonStyling? button;
  final OptionStyling? option;
  final ProgressStyling? progress;
  final BackgroundStyling? background;
  
  final double? roundness;
  final bool? allowStyleOverwrite;
  final bool? overwriteThemeStyling;
  final bool? isLogoHidden;
  final bool? hideProgressBar;
  final bool? isDarkModeEnabled;
  final bool? inAppSurveyBranding;
  final String? logoUrl;

  // Legacy fields for backward compatibility if needed, 
  // but we should prioritize nested ones
  final Map<String, dynamic>? brandColor;
  final Map<String, dynamic>? questionColor;

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
  });

  factory Styling.fromJson(Map<String, dynamic> json) => _$StylingFromJson(json);
  Map<String, dynamic> toJson() => _$StylingToJson(this);
}

@JsonSerializable()
class CardStyling {
  final double? roundness;
  final Map<String, dynamic>? backgroundColor;
  final Map<String, dynamic>? borderColor;
  final Map<String, dynamic>? highlightBorderColor;
  final String? arrangement; // 'straight', 'stacked'
  final Map<String, dynamic>? overlay;
  final String? placement; // 'bottomRight', 'bottomLeft', etc.
  final bool? clickOutsideClose;

  CardStyling({this.roundness, this.backgroundColor, this.borderColor, this.highlightBorderColor, this.arrangement, this.overlay, this.placement, this.clickOutsideClose});
  factory CardStyling.fromJson(Map<String, dynamic> json) => _$CardStylingFromJson(json);
  Map<String, dynamic> toJson() => _$CardStylingToJson(this);
}

@JsonSerializable()
class HeadlineStyling {
  final Map<String, dynamic>? color;
  final int? fontSize;
  final String? fontWeight;
  final Map<String, dynamic>? descriptionColor;
  final int? descriptionFontSize;
  final String? descriptionFontWeight;
  final Map<String, dynamic>? upperLabelColor;
  final int? upperLabelFontSize;
  final String? upperLabelFontWeight;

  HeadlineStyling({this.color, this.fontSize, this.fontWeight, this.descriptionColor, this.descriptionFontSize, this.descriptionFontWeight, this.upperLabelColor, this.upperLabelFontSize, this.upperLabelFontWeight});
  factory HeadlineStyling.fromJson(Map<String, dynamic> json) => _$HeadlineStylingFromJson(json);
  Map<String, dynamic> toJson() => _$HeadlineStylingToJson(this);
}

@JsonSerializable()
class InputStyling {
  final Map<String, dynamic>? backgroundColor;
  final Map<String, dynamic>? borderColor;
  final Map<String, dynamic>? textColor;
  final int? borderRadius;
  final int? height;
  final int? fontSize;
  final int? paddingX;
  final int? paddingY;
  final double? placeholderOpacity;
  final Map<String, dynamic>? shadow;

  InputStyling({this.backgroundColor, this.borderColor, this.textColor, this.borderRadius, this.height, this.fontSize, this.paddingX, this.paddingY, this.placeholderOpacity, this.shadow});
  factory InputStyling.fromJson(Map<String, dynamic> json) => _$InputStylingFromJson(json);
  Map<String, dynamic> toJson() => _$InputStylingToJson(this);
}

@JsonSerializable()
class ButtonStyling {
  final Map<String, dynamic>? backgroundColor;
  final Map<String, dynamic>? textColor;
  final int? borderRadius;
  final int? height;
  final int? fontSize;
  final String? fontWeight;
  final int? paddingX;
  final int? paddingY;

  ButtonStyling({this.backgroundColor, this.textColor, this.borderRadius, this.height, this.fontSize, this.fontWeight, this.paddingX, this.paddingY});
  factory ButtonStyling.fromJson(Map<String, dynamic> json) => _$ButtonStylingFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonStylingToJson(this);
}

@JsonSerializable()
class OptionStyling {
  final Map<String, dynamic>? backgroundColor;
  final Map<String, dynamic>? labelColor;
  final int? borderRadius;
  final int? paddingX;
  final int? paddingY;
  final int? fontSize;
  final Map<String, dynamic>? borderColor;

  OptionStyling({this.backgroundColor, this.labelColor, this.borderRadius, this.paddingX, this.paddingY, this.fontSize, this.borderColor});
  factory OptionStyling.fromJson(Map<String, dynamic> json) => _$OptionStylingFromJson(json);
  Map<String, dynamic> toJson() => _$OptionStylingToJson(this);
}

@JsonSerializable()
class ProgressStyling {
  final Map<String, dynamic>? trackBackgroundColor;
  final Map<String, dynamic>? indicatorBackgroundColor;
  final int? trackHeight;

  ProgressStyling({this.trackBackgroundColor, this.indicatorBackgroundColor, this.trackHeight});
  factory ProgressStyling.fromJson(Map<String, dynamic> json) => _$ProgressStylingFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressStylingToJson(this);
}

@JsonSerializable()
class BackgroundStyling {
  final Map<String, dynamic>? bg;
  final String? bgType; // 'color', 'image', 'animation'
  final String? brightness; // 'light', 'dark'

  BackgroundStyling({this.bg, this.bgType, this.brightness});
  factory BackgroundStyling.fromJson(Map<String, dynamic> json) => _$BackgroundStylingFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundStylingToJson(this);
}