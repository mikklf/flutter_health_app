import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/weight_preprocessor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataPreprocessor weightPreprocessor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    weightPreprocessor = WeightPreprocessor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("WeightPreprocessor", () {
    test("getPreprocessed data with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      var data =
          await weightPreprocessor.getPreprocessedData(startTime, endTime);
      expect(data, isEmpty);
    });

    test("getPreprocessedData with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      await db.insert(
          'weights', {'date': '2022-01-01 04:28:20.432647', 'weight': 70});
      await db.insert(
          'weights', {'date': '2022-01-02 04:28:20.432647', 'weight': 71});
      await db.insert(
          'weights', {'date': '2022-01-03 04:28:20.432647', 'weight': 72});

      var data =
          await weightPreprocessor.getPreprocessedData(startTime, endTime);
      var expectedData = [
        {'Date': '2022-01-01', 'Weight': 70.0},
        {'Date': '2022-01-02', 'Weight': 71.0},
        {'Date': '2022-01-03', 'Weight': 72.0}
      ];
      expect(data, expectedData);
    });
  });
}
