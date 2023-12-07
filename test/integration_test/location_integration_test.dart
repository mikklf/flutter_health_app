import 'package:carp_background_location/carp_background_location.dart';
import 'package:clock/clock.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/logic/location_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    test('Saving locations to database when received from system', () async {
      // Arrange
      SharedPreferences.setMockInitialValues(
          <String, Object>{'home_latitude': 0.0, 'home_longitude': 0.0});

      // Act
      await withClock(Clock.fixed(DateTime(2023, 11, 3, 12, 0, 0)), () async {
        await locationCubit.onLocationUpdates(LocationDto.fromJson({
          'latitude': 0.0,
          'longitude': 0.0,
          'altitude': 0.0,
          'accuracy': 0.0,
          'speed': 0.0,
          'speed_accuracy': 0.0,
          'heading': 0.0,
          'time': 0.0,
          'is_mocked': false,
          'provider': 'fused',
        }));
      });

      // Assert
      var locations = await services
          .get<ILocationRepository>()
          .getLocationsForDay(DateTime(2023, 11, 3));

      expect(locations.length, 1);
      expect(locationCubit.state.homeStayPercent, 100);
    });
  });
}
