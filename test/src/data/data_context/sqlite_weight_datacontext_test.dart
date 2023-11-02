import 'package:flutter_health_app/src/data/data_context/interfaces/weight_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_weight_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IWeightDataContext weightDataContext;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    weightDataContext = WeightDataContext(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group('WeightDataContext', () {
    test('insert() should insert a weight into the database', () async {
      // Arrange
      final weight = {'date': '2022-01-01', 'weight': 70.0};

      // Act
      await weightDataContext.insert(weight);
      final List<Map<String, dynamic>> result =
          await db.query('weights', where: 'id = 1');

      // Assert
      expect(result.length, 1);
      expect(result[0]['date'], weight['date']);
      expect(result[0]['weight'], weight['weight']);
    });

    test('update() should update a weight in the database', () async {
      // Arrange
      final weight = {'date': '2022-01-01', 'weight': 70.0};
      await db.insert('weights', weight);

      final updatedWeight = {'id': 1, 'date': '2022-01-02', 'weight': 72.0};

      // Act
      await weightDataContext.update(updatedWeight);
      final List<Map<String, dynamic>> result =
          await db.query('weights', where: 'id = 1');

      // Assert
      expect(result.length, 1);
      expect(result[0]['date'], updatedWeight['date']);
      expect(result[0]['weight'], updatedWeight['weight']);
    });  

    test('update() should throw an ArgumentError if values does not contain an id field', () async {
      // Arrange
      final weight = {'date': '2022-01-01', 'weight': 70.0};

      // Act & Assert
      expect(() => weightDataContext.insert(weight), throwsA(isA<ArgumentError>()));
    });

    test('getWeightsInRange() should return weights within a date range',
        () async {
      // Arrange
      final weight1 = {'date': '2022-01-01 14:28:11', 'weight': 70.0};
      final weight2 = {'date': '2022-01-02 12:21:22', 'weight': 72.0};
      final weight3 = {'date': '2022-01-03 17:22:32', 'weight': 71.5};
      await db.insert('weights', weight1);
      await db.insert('weights', weight2);
      await db.insert('weights', weight3);

      final startTime = DateTime.parse('2022-01-02 00:00:00');
      final endTime = DateTime.parse('2022-01-03 23:59:59');

      // Act
      final List<Map<String, dynamic>> result =
          await weightDataContext.getWeightsInRange(startTime, endTime);
          
      // Assert
      expect(result.length, 2);
      expect(result[0]['date'], weight2['date']);
      expect(result[0]['weight'], weight2['weight']);
      expect(result[1]['date'], weight3['date']);
      expect(result[1]['weight'], weight3['weight']);
    });

    test('getLastestWeights() should return the latest weights', () async {
      // Arrange
      final weight1 = {'date': '2022-01-01', 'weight': 70.0};
      final weight2 = {'date': '2022-01-02', 'weight': 72.0};
      final weight3 = {'date': '2022-01-03', 'weight': 71.5};
      await db.insert('weights', weight1);
      await db.insert('weights', weight2);
      await db.insert('weights', weight3);

      const numOfEntries = 2;

      // Act
      final List<Map<String, dynamic>> result =
          await weightDataContext.getLastestWeights(numOfEntries);

      // Assert
      expect(result.length, 2);
      expect(result[0]['date'], weight3['date']);
      expect(result[0]['weight'], weight3['weight']);
      expect(result[1]['date'], weight2['date']);
      expect(result[1]['weight'], weight2['weight']);
    });
  });
}
