import 'package:clock/clock.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/logic/location_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../in_memory_database_helper.dart';

void main() {
  late Database db;
  late LocationCubit locationCubit;

  setUp(() async {
    ServiceLocator.setupDependencyInjection();

    db = await InMemoryDatabaseHelper().getDatabase();

    services.unregister<IDatabaseHelper>();
    services.registerFactory<IDatabaseHelper>(() => InMemoryDatabaseHelper());

    locationCubit = LocationCubit(services.get<ILocationRepository>());
  });

  tearDown(() {
    db.close();
    services.reset();
  });

  group('Location integration test', () {
    test('loading locations from database', () async {
      // Arrange
      await db.insert('locations', <String, Object?>{
        'latitude': 0,
        'longitude': 0,
        'is_home': 1,
        'timestamp': DateTime(2023, 1, 1, 6, 0, 0).toString()
      });
      await db.insert('locations', <String, Object?>{
        'latitude': 0,
        'longitude': 0,
        'is_home': 0,
        'timestamp': DateTime(2023, 1, 1, 12, 0, 0).toString()
      });

      await withClock(Clock.fixed(DateTime(2023, 1, 1, 14, 0, 0)), () async {
        await locationCubit.loadLocations();
      });

      // Assert
      expect(locationCubit.state.homeStayPercent, 50);
    });
  });
}
