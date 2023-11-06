import 'package:flutter_health_app/src/data/data_context/interfaces/location_datacontext.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/repositories/location_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationDataContext extends Mock implements ILocationDataContext {}

void main() {
  late LocationRepository locationRepository;
  late ILocationDataContext mockLocationContext;

  setUp(() {
    mockLocationContext = MockLocationDataContext();
    locationRepository = LocationRepository(mockLocationContext);
  });

  group('LocationRepository', () {
    test('insert calls insert on location data context', () async {
      // Arrange
      final location = Location(
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        isHome: false,
      );
      when(() => mockLocationContext.getLastest())
          .thenAnswer((_) => Future.value(null));
      when(() => mockLocationContext.insert(location.toMap()))
          .thenAnswer((_) async => {});

      // Act
      await locationRepository.insert(location);

      // Assert
      verify(() => mockLocationContext.insert(location.toMap()));
    });

    test(
        'getLocationsForDay should return empty list if there are no locations for the given day',
        () async {
      // Arrange
      final date = DateTime.now();
      when(() => mockLocationContext.getLocationsForDay(date))
          .thenAnswer((_) async => []);

      // Act
      final result = await locationRepository.getLocationsForDay(date);

      // Assert
      expect(result, []);
    });

    test(
        'getLocationsForDay should return a list of locations for the given day',
        () async {
      // Arrange
      final date = DateTime.now();
      final locations = [
        Location(
          timestamp: date,
          latitude: 0,
          longitude: 0,
          isHome: false,
        ),
        Location(
          timestamp: date,
          latitude: 1,
          longitude: 1,
          isHome: true,
        ),
      ];
      when(() => mockLocationContext.getLocationsForDay(date)).thenAnswer(
          (_) => Future.value(locations.map((e) => e.toMap()).toList()));

      // Act
      final result = await locationRepository.getLocationsForDay(date);

      // Assert
      expect(result.length, 2);
    });
  });

  test('getLastest should return null if no locations exist', () async {
    // Arrange
    when(() => mockLocationContext.getLastest()).thenAnswer((_) async => null);

    // Act
    final result = await locationRepository.getLastest();

    // Assert
    expect(result, isNull);
  });

  test(
      'getLastest should return a Location object if data context returns a map',
      () async {
    // Arrange
    final locationMap = {
      'latitude': 0.0,
      'longitude': 0.0,
      'timestamp': DateTime(2023, 11, 1, 14, 00, 30).toString(),
      'isHome': false,
    };
    final expectedLocation = Location.fromMap(locationMap);
    when(() => mockLocationContext.getLastest())
        .thenAnswer((_) async => locationMap);

    // Act
    final result = await locationRepository.getLastest();

    // Assert
    expect(result?.toMap(), expectedLocation.toMap());
  });
}
