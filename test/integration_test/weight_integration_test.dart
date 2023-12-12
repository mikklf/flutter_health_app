import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/logic/weights_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../in_memory_database_helper.dart';

void main() {
  late Database db;
  late WeightsCubit weightCubit;

  setUp(() async {
    ServiceLocator.setupDependencyInjection();

    db = await InMemoryDatabaseHelper().getDatabase();

    services.unregister<IDatabaseHelper>();
    services.registerFactory<IDatabaseHelper>(() => InMemoryDatabaseHelper());

    weightCubit = WeightsCubit(services.get<IWeightRepository>());
  });

  tearDown(() {
    db.close();
    services.reset();
  });

  group('Weight integration test', () {
    test('update weights', () async {
      // Arrange
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(hours: 2)), 75);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(hours: 1)), 74);

      // Act
      var result = await db.query('weights');

      // Assert
      expect(result.length, 1);
      expect(result.first['weight'], 74);
    });

    test('load lastest weights with numOfEntries = 7', () async {
      // Arrange
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 8)), 80);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 7)), 79);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 6)), 78);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 5)), 77);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 4)), 76);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 3)), 75);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 2)), 74);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(days: 1)), 73);
      await services
          .get<IWeightRepository>()
          .updateWeight(DateTime.now().subtract(const Duration(hours: 1)), 72.5);

      // Act
      await weightCubit.getLatestWeights();

      // Assert
      expect(weightCubit.state.weightList.length, 7);
      expect(weightCubit.state.weightList.first.weight, 72.5);
      expect(weightCubit.state.weightList.last.weight, 78);
    });
  });
}
