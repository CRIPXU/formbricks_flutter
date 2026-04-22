// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
  id: json['id'] as String,
  name: json['name'] as String,
  logic: (json['logic'] as List<dynamic>?)
      ?.map((e) => Logic.fromJson(e as Map<String, dynamic>))
      .toList(),
  questions: (json['elements'] as List<dynamic>)
      .map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList(),
  buttonLabel: json['buttonLabel'] as Map<String, dynamic>?,
  backButtonLabel: json['backButtonLabel'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logic': instance.logic,
  'elements': instance.questions,
  'buttonLabel': instance.buttonLabel,
  'backButtonLabel': instance.backButtonLabel,
};
