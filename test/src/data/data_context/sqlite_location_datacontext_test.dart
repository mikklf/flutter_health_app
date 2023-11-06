import 'package:flutter_health_app/src/data/data_context/interfaces/location_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_location_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'mock_database_helper.dart';

void main() {
  late IDatabaseHelper databaseHelper;
  late ILocationDataContext locationContext;
  late Database db;

  setUp(() async {
    databaseHelper = MockDatabaseHelper();
    locationContext = LocationDataContext(databaseHelper);
    db = await databaseHelper.getDatabase();
  });

  tearDown(() async {
    // Reset database after each test
    await db.close();
  });

  group("LocationDataContext", () {
    test("Inserts a new location into the database", () async {
      // Arrange
      final location = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2023, 11, 1, 12, 42, 17),
      );

      // Act
      await locationContext.insert(location.toMap());

      // Assert
      final List<Map<String, dynamic>> maps = await db.query("locations");
      expect(maps.length, 1);
      expect(maps.first["latitude"], location.latitude);
      expect(maps.first["longitude"], location.longitude);
      expect(maps.first["is_home"], 0);
      expect(maps.first["timestamp"], location.timestamp.toString());
    });

    test("Returns a list of locations for a given day", () async {
      // Arrange
      final location1 = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2022, 1, 1, 12, 0, 0),
      );
      final location2 = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2022, 1, 2, 12, 0, 0),
      );
      final location3 = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2022, 1, 2, 23, 59, 59),
      );
      await locationContext.insert(location1.toMap());
      await locationContext.insert(location2.toMap());
      await locationContext.insert(location3.toMap());

      // Act
      final locations =
          await locationContext.getLocationsForDay(DateTime(2022, 1, 2));

      // Assert
      expect(locations.length, 2);
      expect(locations[0]["latitude"], location2.latitude);
      expect(locations[0]["longitude"], location2.longitude);
      expect(locations[0]["timestamp"], location2.timestamp.toString());
      expect(locations[1]["latitude"], location3.latitude);
      expect(locations[1]["longitude"], location3.longitude);
      expect(locations[1]["timestamp"], location3.timestamp.toString());
    });

    test("Returns empty list if no locations found for a given day", () async {
      // Arrange
      final location = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2022, 1, 1, 12, 0, 0),
      );
      await locationContext.insert(location.toMap());

      // Act
      final locations =
          await locationContext.getLocationsForDay(DateTime(2022, 1, 2));

      // Assert
      expect(locations, isEmpty);
    });

    test("Returns the last entry in the database", () async {
      // Arrange
      final location1 = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2022, 1, 1, 12, 0, 0),
      );
      final location2 = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        isHome: false,
        timestamp: DateTime(2022, 1, 2, 12, 0, 0),
      );
      await locationContext.insert(location1.toMap());
      await locationContext.insert(location2.toMap());

      // Act
      final latestLocation = await locationContext.getLastest();

      // Assert
      expect(latestLocation!["latitude"], location2.latitude);
      expect(latestLocation["longitude"], location2.longitude);
      expect(latestLocation["timestamp"], location2.timestamp.toString());
    });

    test("Returns null if no locations found in the database", () async {
      // Act
      final latestLocation = await locationContext.getLastest();

      // Assert
      expect(latestLocation, null);
    });
  });
}
