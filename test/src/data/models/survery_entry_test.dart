import 'dart:convert';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/model.dart';

void main() {
  group('SurveyEntry Model', () {
    late DateTime moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);

    setUp(() {
      moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
    });

    test('returns correct SurveyEntry from toMap method', () {
      // Arrange
      SurveyEntry entry = SurveyEntry(
          "test_id", moonLanding, RPTaskResult(identifier: "test_task"));

      // Act
      Map<String, dynamic> map = entry.toMap();

      // Assert
      expect(map['survey_id'], "test_id");
      expect(map['date'], moonLanding.toString());
      expect(map['result'], jsonEncode(entry.result));
    });

    test('returns correct SurveyEntry fromMap method', () {
      // Arrange
      var map = {
        'survey_id': "test_id",
        'date': moonLanding.toString(),
        'result': jsonEncode(RPTaskResult(identifier: "test_task")),
        'id': 1
      };      

      // Act
      SurveyEntry entry = SurveyEntry.fromMap(map);

      // Assert
      expect(entry.surveyId, "test_id");
      expect(entry.date, moonLanding);
      expect(entry.result.identifier, "test_task");
      expect(entry.id, 1);
    });
  });
}
