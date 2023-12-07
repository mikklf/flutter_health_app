import 'package:flutter_health_app/src/data/data_context/interfaces/heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../in_memory_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IHeartRateDataContext heartRateContext;
  late Database db;

  setUp(() async {
    databaseHelper = InMemoryDatabaseHelper();
    heartRateContext = HeartRateDataContext(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group('HeartRateDataContext', () {
    test('Insert new heart rate data into database', () async {
      // Arrange
      final timestamp = DateTime(2023, 11, 1, 10, 15, 43);
      final heartRate = {
        'timestamp': timestamp.toString(),
        'beats_per_minute': 80,
      };

      // Act
      await heartRateContext.insert(heartRate);

      // Assert
      final List<Map<String, dynamic>> maps = await db.query("heart_rate");
      expect(maps.length, 1);
      expect(maps[0]['timestamp'], heartRate['timestamp']);
      expect(maps[0]['beats_per_minute'], heartRate['beats_per_minute']);
    });

    test('Returns a list of heart rates for a given range', () async {
      // Arrange
      final timestamp = DateTime(2023, 11, 1, 10, 15, 43);
      final heartRate = {
        'timestamp': timestamp.toString(),
        'beats_per_minute': 80,
      };

      // Act
      await heartRateContext.insert(heartRate);
      final heartRates = await heartRateContext.getHeartRatesInRange(
        timestamp.subtract(const Duration(minutes: 5)),
        timestamp.add(const Duration(minutes: 5)),
      );

      // Assert
      expect(heartRates.length, 1);
      expect(heartRates[0]['timestamp'], heartRate['timestamp']);
      expect(heartRates[0]['beats_per_minute'], heartRate['beats_per_minute']);
    });

    test('Return empty list if no data found in range', () async {
      // Arrange
      final timestamp = DateTime(2023, 11, 1, 10, 15, 43);

      // Act
      final heartRates = await heartRateContext.getHeartRatesInRange(
          timestamp, timestamp.add(const Duration(hours: 1)));

      // Assert
      expect(heartRates, isEmpty);
    });
  });
}
