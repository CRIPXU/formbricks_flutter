import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:formbricks_flutter/formbricks_flutter.dart';

void main() {
  group('Blocks API Parsing and Logic Test', () {
    const String jsonString = '''
{
  "data": {
    "data": {
      "surveys": [
        {
          "id": "cmo7fh75e000ioho0voj1rea0",
          "name": "Encuesta de valoración de ConfidentialAI",
          "type": "app",
          "status": "inProgress",
          "welcomeCard": {
            "enabled": true,
            "headline": { "default": "Hola" },
            "buttonLabel": { "default": "Empezar" }
          },
          "blocks": [
            {
              "id": "block_1",
              "name": "Block 1",
              "elements": [
                {
                  "id": "q1",
                  "type": "rating",
                  "headline": { "default": "¿Qué te parece?" },
                  "required": true
                }
              ],
              "logic": [
                {
                  "id": "l1",
                  "actions": [
                    { "id": "a1", "target": "block_3", "objective": "jumpToBlock" }
                  ],
                  "conditions": {
                    "id": "c1",
                    "operator": "and",
                    "conditions": [
                      {
                        "id": "cd1",
                        "operator": "isLessThanOrEqual",
                        "leftOperand": { "type": "element", "value": "q1" },
                        "rightOperand": { "type": "static", "value": 3 }
                      }
                    ]
                  }
                }
              ]
            },
            {
              "id": "block_2",
              "name": "Block 2",
              "elements": [
                {
                  "id": "q2",
                  "type": "cta",
                  "headline": { "default": "¡Genial!" }
                }
              ]
            },
            {
              "id": "block_3",
              "name": "Block 3",
              "elements": [
                {
                  "id": "q3",
                  "type": "openText",
                  "headline": { "default": "¿Cómo podemos mejorar?" }
                }
              ]
            }
          ]
        }
      ]
    }
  }
}
''';

    test('Should parse Blocks and Elements correctly', () {
      final Map<String, dynamic> rawJson = jsonDecode(jsonString);
      final surveysJson = rawJson['data']['data']['surveys'] as List;
      final survey = Survey.fromJson(surveysJson.first);

      expect(survey.blocks, isNotNull);
      expect(survey.blocks!.length, equals(3));
      expect(survey.blocks![0].questions.length, equals(1));
      expect(survey.blocks![0].questions[0].type, equals(QuestionType.rating));
      
      // Test Logic parsing
      final logic = survey.blocks![0].logic!.first;
      expect(logic.actions.first.objective, equals(LogicActionObjective.jumpToBlock));
      expect(logic.actions.first.target, equals('block_3'));
      
      // Test Condition parsing (operator alias)
      expect(logic.conditions!.connector, equals(ConditionConnector.and));
    });

    test('Operand type "element" should be parsed correctly', () {
      final Map<String, dynamic> rawJson = jsonDecode(jsonString);
      final surveysJson = rawJson['data']['data']['surveys'] as List;
      final survey = Survey.fromJson(surveysJson.first);
      
      final conditionDetail = logicToConditionDetail(survey.blocks![0].logic!.first.conditions!.conditions.first);
      expect(conditionDetail.leftOperand.type, equals(OperandType.element));
      expect(conditionDetail.leftOperand.value, equals('q1'));
    });
  });
}

// Helper since the conditions list is dynamic
ConditionDetail logicToConditionDetail(dynamic condition) {
  return ConditionDetail.fromJson(condition as Map<String, dynamic>);
}
