
import 'package:json_annotation/json_annotation.dart';

import '../../../formbricks_flutter.dart';
part 'logic.g.dart';
@JsonSerializable()
class Logic {
  final String id;
  final List<LogicAction> actions;
  final Condition? conditions;

  Logic({required this.id, required this.actions, this.conditions});
  factory Logic.fromJson(Map<String, dynamic> json) {
    Condition? parsedConditions;
    if (json['conditions'] != null) {
      if (json['conditions'] is Map) {
        parsedConditions = Condition.fromJson(json['conditions'] as Map<String, dynamic>);
      } else if (json['conditions'] is List) {
        // Si es una lista, creamos un objeto Condition sintético con conector 'and'
        parsedConditions = Condition(
          id: 'synthetic-id',
          connector: ConditionConnector.and,
          conditions: json['conditions'] as List<dynamic>,
        );
      }
    }

    return Logic(
      id: json['id'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => LogicAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      conditions: parsedConditions,
    );
  }
  Map<String, dynamic> toJson() => _$LogicToJson(this);
}

/// A task that is executed when a condition is met
@JsonSerializable()
class LogicAction {
  final String id;
  @JsonKey(name: 'objective')
  final LogicActionObjective objective;
  final String? target;
  final dynamic value; // For calculate actions

  @JsonKey(name: 'operator')
  final LogicActionOperator? operator; // For calculate actions
  final String? variableId; // For variable assignment

  LogicAction({
    required this.id,
    required this.objective,
    this.target,
    this.value,
    this.operator,
    this.variableId
  });
  factory LogicAction.fromJson(Map<String, dynamic> json) => _$LogicActionFromJson(json);
  Map<String, dynamic> toJson() => _$LogicActionToJson(this);
}

/// A rule that determines when an action should be executed.
@JsonSerializable()
class Condition {
  final String id;
  @JsonKey(name: 'operator')
  final ConditionConnector? connector;
  final List<dynamic> conditions;

  Condition({
    required this.id,
    this.connector,
    required this.conditions,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    String? op = (json['operator'] ?? json['connector'])?.toString();
    return Condition(
      id: json['id']?.toString() ?? 'synthetic-id',
      connector: op == 'or' ? ConditionConnector.or : ConditionConnector.and,
      conditions: json['conditions'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'operator': connector?.name,
    'conditions': conditions,
  };
}

@JsonSerializable()
class ConditionDetail {
  final String id;
  @JsonKey(name: 'operator')
  final ConditionOperator? operator;
  final Operand leftOperand;
  final Operand? rightOperand;

  ConditionDetail({
    required this.id,
    this.operator,
    required this.leftOperand,
    this.rightOperand,
  });

  factory ConditionDetail.fromJson(Map<String, dynamic> json) {
    return ConditionDetail(
      id: json['id']?.toString() ?? 'synthetic-detail-id',
      operator: _parseOperator(json['operator']?.toString()),
      leftOperand: Operand.fromJson(json['leftOperand'] as Map<String, dynamic>),
      rightOperand: json['rightOperand'] != null 
          ? Operand.fromJson(json['rightOperand'] as Map<String, dynamic>)
          : null,
    );
  }

  static ConditionOperator _parseOperator(String? op) {
    if (op == null) return ConditionOperator.noOperator;
    return ConditionOperator.values.firstWhere(
      (e) => e.name == op,
      orElse: () => ConditionOperator.noOperator,
    );
  }

  Map<String, dynamic> toJson() => _$ConditionDetailToJson(this);
}

@JsonSerializable()
class Operand {
  @JsonKey(name: 'type')
  final OperandType type;
  final dynamic value;

  Operand({required this.type, this.value});
  factory Operand.fromJson(Map<String, dynamic> json) => _$OperandFromJson(json);
  Map<String, dynamic> toJson() => _$OperandToJson(this);
}