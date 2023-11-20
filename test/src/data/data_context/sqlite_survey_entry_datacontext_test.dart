import 'dart:convert';

import 'package:flutter_health_app/src/data/data_context/interfaces/survey_entry_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_survey_entry_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late ISurveyEntryDataContext surveyEntryContext;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    surveyEntryContext = SurveyEntryDataContext(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group('SurveyEntryDataContext', () {
    test('insert should insert a survey entry into the database', () async {
      // Arrange
      final surveyEntry = SurveyEntry(
          surveyId: '1',
          result: RPTaskResult(identifier: "test_insert_entry"),
          date: DateTime(2023, 11, 1));

      // Act
      await surveyEntryContext.insert(surveyEntry.toMap());
      final List<Map<String, dynamic>> result =
          await db.query('survey_entries');

      // Assert
      expect(result.length, 1);
      expect(result[0]['survey_id'], surveyEntry.surveyId);
      expect(result[0]['result'], jsonEncode(surveyEntry.result.toJson()));
    });

    test('getLastEntryOfType should return the last entry of a survey',
        () async {
      // Arrange
      const surveyId = 'dummy_survey';
      final surveyEntry1 = SurveyEntry(
          surveyId: surveyId,
          result: RPTaskResult(identifier: "test_insert_entry"),
          date: DateTime(2023, 11, 1));
      final surveyEntry2 = SurveyEntry(
          surveyId: surveyId,
          result: RPTaskResult(identifier: "test_insert_entry"),
          date: DateTime(2023, 11, 2));
      await surveyEntryContext.insert(surveyEntry1.toMap());
      await surveyEntryContext.insert(surveyEntry2.toMap());

      // Act
      final Map<String, dynamic>? result =
          await surveyEntryContext.getLastEntryOfType(surveyId);

      // Assert
      expect(result, isNotNull);
      expect(result!['date'], surveyEntry2.date.toString());
    });

    test('getLastEntryOfType should return null if no entry is found',
        () async {
      // Arrange
      const surveyId = 'dummy_survey';

      // Act
      final Map<String, dynamic>? result =
          await surveyEntryContext.getLastEntryOfType(surveyId);

      // Assert
      expect(result, isNull);
    });
  });
}
