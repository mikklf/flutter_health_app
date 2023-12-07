import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/step_datacontext.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/logic/heart_rate_cubit.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/logic/steps_cubit.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../in_memory_database_helper.dart';

class MockHealthProvider extends Mock implements IHealthProvider {}

void main() {
  late Database db;
  late SyncCubit syncCubit;
  late HeartRateCubit heartRateCubit;
  late StepsCubit stepsCubit;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues(<String, Object>{});

    ServiceLocator.setupDependencyInjection();

    db = await InMemoryDatabaseHelper().getDatabase();

    services.unregister<IDatabaseHelper>();
    services.registerSingleton<IDatabaseHelper>(InMemoryDatabaseHelper());

    services.unregister<IHealthProvider>();
    services.registerSingleton<IHealthProvider>(MockHealthProvider());

    heartRateCubit = HeartRateCubit(services.get<IHeartRateRepository>());
    stepsCubit = StepsCubit(services.get<IStepRepository>());
    syncCubit = SyncCubit(
        services.get<IStepRepository>(), services.get<IHeartRateRepository>());
  });

  tearDown(() {
    db.close();
    services.reset();
  });

  group('Health integration test', () {
    test('Syncing health data with database', () async {
      // Arrange
      final healthDataPoint = HealthDataPoint(
          NumericHealthValue(80),
          HealthDataType.HEART_RATE,
          HealthDataUnit.BEATS_PER_MINUTE,
          DateTime(2021, 1, 1),
          DateTime(2021, 1, 1),
          PlatformType.ANDROID,
          'device_id',
          'source_id',
          'source_name');

      when(() => services.get<IHealthProvider>().getSteps(any(), any()))
          .thenAnswer((_) async => 5000);

      when(() => services.get<IHealthProvider>().getHeartbeats(any(), any()))
          .thenAnswer((_) async => [healthDataPoint]);

      // Act
      await withClock(Clock.fixed(DateTime(2021, 1, 1, 6, 0, 0)), () async {
        await syncCubit.syncAll();
      });

      // Assert
      expect(syncCubit.state.isSyncing, false);

      var steps = await services.get<IStepRepository>().getStepsInRange(
          DateTime(2021, 1, 1, 0, 0, 0), DateTime(2021, 1, 1, 23, 59, 59));
      var heartRates = await services
          .get<IHeartRateRepository>()
          .getHeartRatesInRange(
              DateTime(2021, 1, 1, 0, 0, 0), DateTime(2021, 1, 1, 23, 59, 59));

      expect(steps.length, 1);
      expect(steps[0].steps, 5000);

      expect(heartRates.length, 1);
      expect(heartRates[0].beatsPerMinute, 80);
    });

    test('get heart rates for the day', () async {
      // Arrange
      final mockHeartRate =
          HeartRate(beatsPerMinute: 70, timestamp: DateTime.now());

      await db.insert('heart_rate', mockHeartRate.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Act
      await heartRateCubit.getHeartRatesForDay();

      // Assert
      expect(heartRateCubit.state.heartRateList.length, 1);
      expect(heartRateCubit.state.heartRateList[0].beatsPerMinute, 70);
    });

    test('get lastest steps', () async {
      // Arrange
      var today = DateTime.now();

      await db.insert(
          'steps',
          <String, Object?>{
            'date': today.subtract(const Duration(days: 17)).toString(),
            'steps': 4000,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert(
          'steps',
          <String, Object?>{
            'date': today.subtract(const Duration(days: 4)).toString(),
            'steps': 1000,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert(
          'steps',
          <String, Object?>{
            'date': today.subtract(const Duration(days: 2)).toString(),
            'steps': 2000,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert(
          'steps',
          <String, Object?>{
            'date': today.subtract(const Duration(days: 1)).toString(),
            'steps': 3000,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert(
          'steps',
          <String, Object?>{
            'date': today.toString(),
            'steps': 4000,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Act
      await stepsCubit.getLastestSteps();

      // Assert
      expect(stepsCubit.state.stepsList.length, 7);
      expect(stepsCubit.state.stepsList[0].steps, 0);
      expect(stepsCubit.state.stepsList[1].steps, 0);
      expect(stepsCubit.state.stepsList[2].steps, 1000);
      expect(stepsCubit.state.stepsList[3].steps, 0);
      expect(stepsCubit.state.stepsList[4].steps, 2000);
      expect(stepsCubit.state.stepsList[5].steps, 3000);
      expect(stepsCubit.state.stepsList[6].steps, 4000);
    });
  });
}
