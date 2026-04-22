import 'package:json_annotation/json_annotation.dart';
import 'logic.dart';
import 'question.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  final String id;
  final String name;
  final List<Logic>? logic;
  @JsonKey(name: 'elements')
  final List<Question> questions;
  final Map<String, dynamic>? buttonLabel;
  final Map<String, dynamic>? backButtonLabel;

  Block({
    required this.id,
    required this.name,
    this.logic,
    required this.questions,
    this.buttonLabel,
    this.backButtonLabel,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
