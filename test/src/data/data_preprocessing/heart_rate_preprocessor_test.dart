import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/data/data_extraction/heart_rate_data_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataExtractor heartRatePreprocessor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    heartRatePreprocessor = HeartRateDataExtractor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("HeartRatePreprocessor", () {
    test("getPreprocessedData with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      var data =
          await heartRatePreprocessor.getData(startTime, endTime);

      expect(data, isEmpty);
    });

    test("getPreprocessedData with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      await db.insert('heart_rate',
          {'beats_per_minute': 60, 'timestamp': "2022-01-01 10:30:55"});
      await db.insert('heart_rate',
          {'beats_per_minute': 70, 'timestamp': "2022-01-01 11:30:55"});
      await db.insert('heart_rate',
          {'beats_per_minute': 80, 'timestamp': "2022-01-02 10:30:55"});
      await db.insert('heart_rate',
          {'beats_per_minute': 90, 'timestamp': "2022-01-02 11:30:55"});

      var data =
          await heartRatePreprocessor.getData(startTime, endTime);

      var expected = [
        {
          'Date': "2022-01-01",
          'AverageHeartRate': 65,
          'MinHeartRate': 60,
          'MaxHeartRate': 70
        },
        {
          'Date': "2022-01-02",
          'AverageHeartRate': 85,
          'MinHeartRate': 80,
          'MaxHeartRate': 90
        },
      ];

      expect(data, expected);
    });
  });
}
