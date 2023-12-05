import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/data/data_extraction/steps_data_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../../mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IDataExtractor stepsDataExtractor;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    stepsDataExtractor = StepsDataExtractor(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("StepsDataExtractor", () {
    test("get data with no data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      var data =
          await stepsDataExtractor.getData(startTime, endTime);
      expect(data, isEmpty);
    });

    test("get data with data", () async {
      var startTime = DateTime(2022, 1, 1, 0, 0, 0);
      var endTime = DateTime(2022, 1, 3, 23, 59, 59);

      await db.insert(
          'steps', {'date': '2022-01-01 04:28:20.432647', 'steps': 5000});
      await db.insert(
          'steps', {'date': '2022-01-02 04:28:20.432647', 'steps': 6000});
      await db.insert(
          'steps', {'date': '2022-01-03 04:28:20.432647', 'steps': 7000});

      var data =
          await stepsDataExtractor.getData(startTime, endTime);

      var expected = [
        {'Date': '2022-01-01', 'Steps': 5000},
        {'Date': '2022-01-02', 'Steps': 6000},
        {'Date': '2022-01-03', 'Steps': 7000},
      ];

      expect(data, expected);
    });
  });
}
