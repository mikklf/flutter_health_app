import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/extractors/weight_data_extractor.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataExtractor weightDataExtractor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    weightDataExtractor = WeightDataExtractor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("WeightDataExtractor", () {
    test("get data with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      var data =
          await weightDataExtractor.getData(startTime, endTime);
      expect(data, isEmpty);
    });

    test("get data with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      await db.insert(
          'weights', {'date': '2022-01-01 04:28:20.432647', 'weight': 70});
      await db.insert(
          'weights', {'date': '2022-01-02 04:28:20.432647', 'weight': 71});
      await db.insert(
          'weights', {'date': '2022-01-03 04:28:20.432647', 'weight': 72});

      var data =
          await weightDataExtractor.getData(startTime, endTime);
      var expectedData = [
        {'Date': '2022-01-01', 'Weight': 70.0},
        {'Date': '2022-01-02', 'Weight': 71.0},
        {'Date': '2022-01-03', 'Weight': 72.0}
      ];
      expect(data, expectedData);
    });
  });
}
