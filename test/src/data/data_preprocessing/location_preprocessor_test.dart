import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/location_preprocessor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataPreprocessor locationPreprocessor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    locationPreprocessor = LocationPreprocessor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("LocationPreprocessor", () {
    test("getPreprocessedData with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 2, 23, 59, 59);

      var data =
          await locationPreprocessor.getPreprocessedData(startTime, endTime);

      expect(data, isEmpty);
    });

    test("getPreprocessedData with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 2, 23, 59, 59);

      await db.insert('locations', {
        'latitude': 0,
        'longitude': 0,
        'is_home': 1,
        'timestamp': "2022-01-01 04:18:54.256791"
      });
      await db.insert('locations', {
        'latitude': 0,
        'longitude': 0,
        'is_home': 1,
        'timestamp': "2022-01-01 05:18:54.256791"
      });
      await db.insert('locations', {
        'latitude': 1,
        'longitude': 1,
        'is_home': 0,
        'timestamp': "2022-01-02 06:18:54.256791"
      });
      await db.insert('locations', {
        'latitude': 1,
        'longitude': 1,
        'is_home': 0,
        'timestamp': "2022-01-02 07:18:54.256791"
      });

      var data =
          await locationPreprocessor.getPreprocessedData(startTime, endTime);

      var expected = [
        {'Date': '2022-01-01', 'HomestayPercent': 100.0},
        {'Date': '2022-01-02', 'HomestayPercent': 0.0},
      ];

      expect(data, expected);
    });
  });
}
