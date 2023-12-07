import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/logic/heart_rate_cubit.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../in_memory_database_helper.dart';

void main() {
  late Database db;
  late HeartRateCubit heartRateCubit;

  setUp(() async {
    ServiceLocator.setupDependencyInjection();

    db = await InMemoryDatabaseHelper().getDatabase();

    services.unregister<IDatabaseHelper>();
    services.registerFactory<IDatabaseHelper>(() => InMemoryDatabaseHelper());

    heartRateCubit = HeartRateCubit(services.get<IHeartRateRepository>());
  });

  tearDown(() {
    heartRateCubit.close();
    services.reset();
  });

  group('Heart rate cubit integration test', () {
    test('emits HeartRateState with rates for the day', () async {
      // Arrange
      final mockHeartRate = HeartRate(
          beatsPerMinute: 70, timestamp: DateTime.now());

      db.insert('heart_rate', mockHeartRate.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Act
      await heartRateCubit.getHeartRatesForDay();

      // Assert
      expect(heartRateCubit.state.heartRateList.length, 1);
      expect(heartRateCubit.state.heartRateList[0].beatsPerMinute, 70);
    });
  });
}
