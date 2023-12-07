import 'package:flutter_health_app/src/data/data_context/interfaces/step_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_step_datacontext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../in_memory_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late IStepDataContext stepContext;
  late Database db;

  setUp(() async {
    databaseHelper = InMemoryDatabaseHelper();
    stepContext = StepDataContext(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group('StepDataContext', () {
    test('insert should insert a row into the database', () async {
      // Arrange
      final Map<String, Object?> values = {
        'date': DateTime(2023, 11, 1).toString(),
        'steps': 1000,
      };

      // Act
      await stepContext.insert(values);

      // Assert
      final List<Map<String, dynamic>> result = await db.query('steps');
      expect(result.length, 1);
      expect(result.first['date'], values['date']);
      expect(result.first['steps'], values['steps']);
    });

    test('update should update a row in the database', () async {
      // Arrange
      await db.insert('steps', {
        'date': DateTime(2023, 11, 1, 11, 00).toString(),
        'steps': 1000,
      });

      final Map<String, Object?> values = {
        'id': 1,
        'date': DateTime(2023, 11, 1, 12, 00).toString(),
        'steps': 2000,
      };

      // Act
      await stepContext.update(values);

      // Assert
      final List<Map<String, dynamic>> result =
          await db.query('steps', where: 'id = 1');
      expect(result.length, 1);
      expect(result.first['date'], values['date']);
      expect(result.first['steps'], values['steps']);
    });

    test(
        'update() should throw an ArgumentError if values does not contain an id field',
        () async {
      // Arrange
      final steps = {
        'date': DateTime(2023, 11, 1, 12, 00).toString(),
        'steps': 2000
      };

      // Act & Assert
      expect(() => stepContext.update(steps), throwsA(isA<ArgumentError>()));
    });

    test('getStepsForDay should return the steps for a given day', () async {
      // Arrange
      final DateTime date = DateTime(2023, 11, 1);
      final Map<String, Object?> values = {
        'date': date.toString(),
        'steps': 3000,
      };
      await db.insert('steps', values);

      // Act
      final Map<String, dynamic>? result =
          await stepContext.getStepsForDay(date);

      // Assert
      expect(result, isNotNull);
      expect(result!['date'], values['date']);
      expect(result['steps'], values['steps']);
    });

    test('getSteps should return the steps between two dates', () async {
      // Arrange
      final DateTime date = DateTime(2023, 11, 2);
      final Map<String, Object?> values1 = {
        'date': date.toString(),
        'steps': 4000,
      };
      final Map<String, Object?> values2 = {
        'date': date.subtract(const Duration(days: 1)).toString(),
        'steps': 5000,
      };
      await db.insert('steps', values1);
      await db.insert('steps', values2);

      // Act
      final List<Map<String, dynamic>> result = await stepContext.getSteps(
          date.subtract(const Duration(days: 1)), date);

      // Assert
      expect(result.length, 2);
      expect(result[0]['date'], values1['date']);
      expect(result[0]['steps'], values1['steps']);
      expect(result[1]['date'], values2['date']);
      expect(result[1]['steps'], values2['steps']);
    });
  });
}
