import 'dart:io';

import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/data/data_extraction/survey_result_data_extractor/kellner_result_data_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataExtractor kellnerResultDataExtractor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    kellnerResultDataExtractor = KellnerResultDataExtractor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("KellnerResultDataExtractor", () {
    test("getData with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2023, 1, 2, 23, 59, 59);

      var data = await kellnerResultDataExtractor.getData(
          startTime, endTime);

      expect(data, isEmpty);
    });

    test("getData with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2023, 1, 2, 23, 59, 59);

      // read data from testResult1.txt
      var testData1 = await File(
              '${Directory.current.path}/test/src/data/data_extraction/survey_result_data_extractor/testResult1.txt')
          .readAsString();
      var testData2 = await File(
              '${Directory.current.path}/test/src/data/data_extraction/survey_result_data_extractor/testResult2.txt')
          .readAsString();

      // insert data into database
      await db.insert("survey_entries", {
        "survey_id": "kellner",
        "date": "2022-01-01 04:54:00",
        "result": testData1,
      });
      await db.insert("survey_entries", {
        "survey_id": "kellner",
        "date": "2022-01-02 04:55:00",
        "result": testData2,
      });

      var extractedData = await kellnerResultDataExtractor.getData(
          startTime, endTime);

      var expected = [
        {
          'Date': "2022-01-01",
          'DepressionScaleScore': 17,
          'DepressionSubscaleScore': 17,
          'ContentmentSubscaleScore': 6
        },
        {
          'Date': "2022-01-02",
          'DepressionScaleScore': 6,
          'DepressionSubscaleScore': 0,
          'ContentmentSubscaleScore': 0
        },
      ];

      expect(extractedData, expected);
    });
  });
}
