import 'package:flutter_health_app/domain/interfaces/location_provider.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/repositories/location_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationProvider extends Mock implements ILocationProvider {}

void main() {
  late LocationRepository locationRepository;
  late ILocationProvider mockLocationProvider;

  setUp(() {
    mockLocationProvider = MockLocationProvider();
    locationRepository = LocationRepository(mockLocationProvider);
  });

  group('LocationRepository', () {
    test('insert should return true if there is no previous location',
        () async {
      // Arrange
      final location =
          Location(date: DateTime.now(), latitude: 0.0, longitude: 0.0);
      when(() => mockLocationProvider.getLastest())
          .thenAnswer((_) => Future.value(null));
      when(() => mockLocationProvider.insert(location.toMap()))
          .thenAnswer((_) async => {});

      // Act
      final result = await locationRepository.insert(location);

      // Assert
      expect(result, true);
      verify(() => mockLocationProvider.insert(location.toMap()));
    });

    test(
        'insert should return false if the last entry is less than 10 minutes old',
        () async {
      // Arrange
      final location =
          Location(date: DateTime.now(), latitude: 0, longitude: 0);
      final lastLocation = Location(
          date: DateTime.now().subtract(const Duration(minutes: 5)),
          latitude: 0,
          longitude: 0);
      when(() => mockLocationProvider.getLastest())
          .thenAnswer((_) => Future.value(lastLocation.toMap()));
      when(() => mockLocationProvider.insert(location.toMap()))
          .thenAnswer((_) async => {});

      // Act
      final result = await locationRepository.insert(location);

      // Assert
      expect(result, false);
      verifyNever(() => mockLocationProvider.insert(location.toMap()));
    });

    test(
        'insert should insert the location if the last entry is more than 10 minutes old',
        () async {
      // Arrange
      final location =
          Location(date: DateTime.now(), latitude: 0, longitude: 0);
      final lastLocation = Location(
          date: DateTime.now().subtract(const Duration(minutes: 15)),
          latitude: 0,
          longitude: 0);
      when(() => mockLocationProvider.getLastest())
          .thenAnswer((_) => Future.value(lastLocation.toMap()));
      when(() => mockLocationProvider.insert(location.toMap()))
          .thenAnswer((_) async => {});

      // Act
      final result = await locationRepository.insert(location);

      // Assert
      expect(result, true);
      verify(() => mockLocationProvider.insert(location.toMap()));
    });

    test(
        'getLocationsForDay should return empty list if there are no locations for the given day',
        () async {
      // Arrange
      final date = DateTime.now();
      when(() => mockLocationProvider.getLocationsForDay(date))
          .thenAnswer((_) => Future.value([]));

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
        Location(date: date, latitude: 0, longitude: 0),
        Location(date: date, latitude: 1, longitude: 1),
      ];
      when(() => mockLocationProvider.getLocationsForDay(date)).thenAnswer(
          (_) => Future.value(locations.map((e) => e.toMap()).toList()));

      // Act
      final result = await locationRepository.getLocationsForDay(date);

      // Assert
      expect(result.length, 2);
    });
  });
}
