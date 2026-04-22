// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'styling.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Styling _$StylingFromJson(Map<String, dynamic> json) => Styling(
  card: json['card'] == null
      ? null
      : CardStyling.fromJson(json['card'] as Map<String, dynamic>),
  headline: json['headline'] == null
      ? null
      : HeadlineStyling.fromJson(json['headline'] as Map<String, dynamic>),
  input: json['input'] == null
      ? null
      : InputStyling.fromJson(json['input'] as Map<String, dynamic>),
  button: json['button'] == null
      ? null
      : ButtonStyling.fromJson(json['button'] as Map<String, dynamic>),
  option: json['option'] == null
      ? null
      : OptionStyling.fromJson(json['option'] as Map<String, dynamic>),
  progress: json['progress'] == null
      ? null
      : ProgressStyling.fromJson(json['progress'] as Map<String, dynamic>),
  background: json['background'] == null
      ? null
      : BackgroundStyling.fromJson(json['background'] as Map<String, dynamic>),
  roundness: json['roundness'],
  allowStyleOverwrite: json['allowStyleOverwrite'] as bool?,
  overwriteThemeStyling: json['overwriteThemeStyling'] as bool?,
  isLogoHidden: json['isLogoHidden'] as bool?,
  hideProgressBar: json['hideProgressBar'] as bool?,
  isDarkModeEnabled: json['isDarkModeEnabled'] as bool?,
  inAppSurveyBranding: json['inAppSurveyBranding'] as bool?,
  logoUrl: json['logoUrl'] as String?,
  brandColor: json['brandColor'] as Map<String, dynamic>?,
  questionColor: json['questionColor'] as Map<String, dynamic>?,
  cardBackgroundColor: json['cardBackgroundColor'] as Map<String, dynamic>?,
  cardBorderColor: json['cardBorderColor'] as Map<String, dynamic>?,
  cardShadowColor: json['cardShadowColor'] as Map<String, dynamic>?,
  highlightBorderColor: json['highlightBorderColor'] as Map<String, dynamic>?,
  inputColor: json['inputColor'] as Map<String, dynamic>?,
  inputBorderColor: json['inputBorderColor'] as Map<String, dynamic>?,
  inputTextColor: json['inputTextColor'] as Map<String, dynamic>?,
  buttonBgColor: json['buttonBgColor'] as Map<String, dynamic>?,
  buttonTextColor: json['buttonTextColor'] as Map<String, dynamic>?,
  optionBgColor: json['optionBgColor'] as Map<String, dynamic>?,
  optionLabelColor: json['optionLabelColor'] as Map<String, dynamic>?,
  optionBorderColor: json['optionBorderColor'] as Map<String, dynamic>?,
  progressTrackBgColor: json['progressTrackBgColor'] as Map<String, dynamic>?,
  progressIndicatorBgColor:
      json['progressIndicatorBgColor'] as Map<String, dynamic>?,
  elementHeadlineColor: json['elementHeadlineColor'] as Map<String, dynamic>?,
  elementDescriptionColor:
      json['elementDescriptionColor'] as Map<String, dynamic>?,
  elementUpperLabelColor:
      json['elementUpperLabelColor'] as Map<String, dynamic>?,
  inputBorderRadius: json['inputBorderRadius'],
  inputHeight: json['inputHeight'],
  inputFontSize: json['inputFontSize'],
  inputPaddingX: json['inputPaddingX'],
  inputPaddingY: json['inputPaddingY'],
  inputPlaceholderOpacity: json['inputPlaceholderOpacity'],
  inputShadow: json['inputShadow'],
  buttonBorderRadius: json['buttonBorderRadius'],
  buttonHeight: json['buttonHeight'],
  buttonFontSize: json['buttonFontSize'],
  buttonFontWeight: json['buttonFontWeight'],
  buttonPaddingX: json['buttonPaddingX'],
  buttonPaddingY: json['buttonPaddingY'],
  optionBorderRadius: json['optionBorderRadius'],
  optionFontSize: json['optionFontSize'],
  optionPaddingX: json['optionPaddingX'],
  optionPaddingY: json['optionPaddingY'],
  progressTrackHeight: json['progressTrackHeight'],
  elementHeadlineFontSize: json['elementHeadlineFontSize'],
  elementHeadlineFontWeight: json['elementHeadlineFontWeight'],
  elementDescriptionFontSize: json['elementDescriptionFontSize'],
  elementDescriptionFontWeight: json['elementDescriptionFontWeight'],
  elementUpperLabelFontSize: json['elementUpperLabelFontSize'],
  elementUpperLabelFontWeight: json['elementUpperLabelFontWeight'],
  cardArrangement: json['cardArrangement'],
);

Map<String, dynamic> _$StylingToJson(Styling instance) => <String, dynamic>{
  'card': instance.card,
  'headline': instance.headline,
  'input': instance.input,
  'button': instance.button,
  'option': instance.option,
  'progress': instance.progress,
  'background': instance.background,
  'roundness': instance.roundness,
  'allowStyleOverwrite': instance.allowStyleOverwrite,
  'overwriteThemeStyling': instance.overwriteThemeStyling,
  'isLogoHidden': instance.isLogoHidden,
  'hideProgressBar': instance.hideProgressBar,
  'isDarkModeEnabled': instance.isDarkModeEnabled,
  'inAppSurveyBranding': instance.inAppSurveyBranding,
  'logoUrl': instance.logoUrl,
  'brandColor': instance.brandColor,
  'questionColor': instance.questionColor,
  'cardBackgroundColor': instance.cardBackgroundColor,
  'cardBorderColor': instance.cardBorderColor,
  'cardShadowColor': instance.cardShadowColor,
  'highlightBorderColor': instance.highlightBorderColor,
  'inputColor': instance.inputColor,
  'inputBorderColor': instance.inputBorderColor,
  'inputTextColor': instance.inputTextColor,
  'buttonBgColor': instance.buttonBgColor,
  'buttonTextColor': instance.buttonTextColor,
  'optionBgColor': instance.optionBgColor,
  'optionLabelColor': instance.optionLabelColor,
  'optionBorderColor': instance.optionBorderColor,
  'progressTrackBgColor': instance.progressTrackBgColor,
  'progressIndicatorBgColor': instance.progressIndicatorBgColor,
  'elementHeadlineColor': instance.elementHeadlineColor,
  'elementDescriptionColor': instance.elementDescriptionColor,
  'elementUpperLabelColor': instance.elementUpperLabelColor,
  'inputBorderRadius': instance.inputBorderRadius,
  'inputHeight': instance.inputHeight,
  'inputFontSize': instance.inputFontSize,
  'inputPaddingX': instance.inputPaddingX,
  'inputPaddingY': instance.inputPaddingY,
  'inputPlaceholderOpacity': instance.inputPlaceholderOpacity,
  'inputShadow': instance.inputShadow,
  'buttonBorderRadius': instance.buttonBorderRadius,
  'buttonHeight': instance.buttonHeight,
  'buttonFontSize': instance.buttonFontSize,
  'buttonFontWeight': instance.buttonFontWeight,
  'buttonPaddingX': instance.buttonPaddingX,
  'buttonPaddingY': instance.buttonPaddingY,
  'optionBorderRadius': instance.optionBorderRadius,
  'optionFontSize': instance.optionFontSize,
  'optionPaddingX': instance.optionPaddingX,
  'optionPaddingY': instance.optionPaddingY,
  'progressTrackHeight': instance.progressTrackHeight,
  'elementHeadlineFontSize': instance.elementHeadlineFontSize,
  'elementHeadlineFontWeight': instance.elementHeadlineFontWeight,
  'elementDescriptionFontSize': instance.elementDescriptionFontSize,
  'elementDescriptionFontWeight': instance.elementDescriptionFontWeight,
  'elementUpperLabelFontSize': instance.elementUpperLabelFontSize,
  'elementUpperLabelFontWeight': instance.elementUpperLabelFontWeight,
  'cardArrangement': instance.cardArrangement,
};

CardStyling _$CardStylingFromJson(Map<String, dynamic> json) => CardStyling(
  roundness: json['roundness'],
  backgroundColor: json['backgroundColor'] as Map<String, dynamic>?,
  borderColor: json['borderColor'] as Map<String, dynamic>?,
  highlightBorderColor: json['highlightBorderColor'] as Map<String, dynamic>?,
  arrangement: json['arrangement'] as String?,
  overlay: json['overlay'] as Map<String, dynamic>?,
  placement: json['placement'] as String?,
  clickOutsideClose: json['clickOutsideClose'] as bool?,
);

Map<String, dynamic> _$CardStylingToJson(CardStyling instance) =>
    <String, dynamic>{
      'roundness': instance.roundness,
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'highlightBorderColor': instance.highlightBorderColor,
      'arrangement': instance.arrangement,
      'overlay': instance.overlay,
      'placement': instance.placement,
      'clickOutsideClose': instance.clickOutsideClose,
    };

HeadlineStyling _$HeadlineStylingFromJson(Map<String, dynamic> json) =>
    HeadlineStyling(
      color: json['color'] as Map<String, dynamic>?,
      fontSize: json['fontSize'],
      fontWeight: json['fontWeight'],
      descriptionColor: json['descriptionColor'] as Map<String, dynamic>?,
      descriptionFontSize: json['descriptionFontSize'],
      descriptionFontWeight: json['descriptionFontWeight'],
      upperLabelColor: json['upperLabelColor'] as Map<String, dynamic>?,
      upperLabelFontSize: json['upperLabelFontSize'],
      upperLabelFontWeight: json['upperLabelFontWeight'],
    );

Map<String, dynamic> _$HeadlineStylingToJson(HeadlineStyling instance) =>
    <String, dynamic>{
      'color': instance.color,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'descriptionColor': instance.descriptionColor,
      'descriptionFontSize': instance.descriptionFontSize,
      'descriptionFontWeight': instance.descriptionFontWeight,
      'upperLabelColor': instance.upperLabelColor,
      'upperLabelFontSize': instance.upperLabelFontSize,
      'upperLabelFontWeight': instance.upperLabelFontWeight,
    };

InputStyling _$InputStylingFromJson(Map<String, dynamic> json) => InputStyling(
  backgroundColor: json['backgroundColor'] as Map<String, dynamic>?,
  borderColor: json['borderColor'] as Map<String, dynamic>?,
  textColor: json['textColor'] as Map<String, dynamic>?,
  borderRadius: json['borderRadius'],
  height: json['height'],
  fontSize: json['fontSize'],
  paddingX: json['paddingX'],
  paddingY: json['paddingY'],
  placeholderOpacity: json['placeholderOpacity'],
  shadow: json['shadow'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$InputStylingToJson(InputStyling instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'textColor': instance.textColor,
      'borderRadius': instance.borderRadius,
      'height': instance.height,
      'fontSize': instance.fontSize,
      'paddingX': instance.paddingX,
      'paddingY': instance.paddingY,
      'placeholderOpacity': instance.placeholderOpacity,
      'shadow': instance.shadow,
    };

ButtonStyling _$ButtonStylingFromJson(Map<String, dynamic> json) =>
    ButtonStyling(
      backgroundColor: json['backgroundColor'] as Map<String, dynamic>?,
      textColor: json['textColor'] as Map<String, dynamic>?,
      borderRadius: json['borderRadius'],
      height: json['height'],
      fontSize: json['fontSize'],
      fontWeight: json['fontWeight'],
      paddingX: json['paddingX'],
      paddingY: json['paddingY'],
    );

Map<String, dynamic> _$ButtonStylingToJson(ButtonStyling instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'borderRadius': instance.borderRadius,
      'height': instance.height,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'paddingX': instance.paddingX,
      'paddingY': instance.paddingY,
    };

OptionStyling _$OptionStylingFromJson(Map<String, dynamic> json) =>
    OptionStyling(
      backgroundColor: json['backgroundColor'] as Map<String, dynamic>?,
      labelColor: json['labelColor'] as Map<String, dynamic>?,
      borderRadius: json['borderRadius'],
      paddingX: json['paddingX'],
      paddingY: json['paddingY'],
      fontSize: json['fontSize'],
      borderColor: json['borderColor'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$OptionStylingToJson(OptionStyling instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'labelColor': instance.labelColor,
      'borderRadius': instance.borderRadius,
      'paddingX': instance.paddingX,
      'paddingY': instance.paddingY,
      'fontSize': instance.fontSize,
      'borderColor': instance.borderColor,
    };

ProgressStyling _$ProgressStylingFromJson(Map<String, dynamic> json) =>
    ProgressStyling(
      trackBackgroundColor:
          json['trackBackgroundColor'] as Map<String, dynamic>?,
      indicatorBackgroundColor:
          json['indicatorBackgroundColor'] as Map<String, dynamic>?,
      trackHeight: json['trackHeight'],
    );

Map<String, dynamic> _$ProgressStylingToJson(ProgressStyling instance) =>
    <String, dynamic>{
      'trackBackgroundColor': instance.trackBackgroundColor,
      'indicatorBackgroundColor': instance.indicatorBackgroundColor,
      'trackHeight': instance.trackHeight,
    };

BackgroundStyling _$BackgroundStylingFromJson(Map<String, dynamic> json) =>
    BackgroundStyling(
      bg: json['bg'],
      bgType: json['bgType'] as String?,
      brightness: json['brightness'],
      logo: json['logo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BackgroundStylingToJson(BackgroundStyling instance) =>
    <String, dynamic>{
      'bg': instance.bg,
      'bgType': instance.bgType,
      'brightness': instance.brightness,
      'logo': instance.logo,
    };
