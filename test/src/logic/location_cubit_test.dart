import 'package:bloc_test/bloc_test.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:clock/clock.dart';
import 'package:flutter_health_app/src/logic/location_cubit.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationRepository extends Mock implements ILocationRepository {}

class LocationFake extends Fake implements Location {}

void main() {
  late ILocationRepository locationRepository;
  late LocationCubit locationCubit;

  setUpAll(() {
    registerFallbackValue(LocationFake());
  });

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    locationRepository = MockLocationRepository();
    locationCubit = LocationCubit(locationRepository);
  });

  group('LocationCubit', () {
    test('initial state is LocationState(0)', () {
      expect(locationCubit.state, const LocationState(0));
    });

    blocTest<LocationCubit, LocationState>(
      'emits LocationState with homeStayPercent when loadLocations is called',
      build: () {
        when(() => locationRepository.getLocationsForDay(any()))
            .thenAnswer((_) async => [
                  Location(
                    longitude: 0,
                    latitude: 0,
                    isHome: true,
                    timestamp: DateTime(2023, 11, 3, 6, 0, 0),
                  )
                ]);

        SharedPreferences.setMockInitialValues(
            <String, Object>{'home_latitude': 0.0, 'home_longitude': 0.0});

        return locationCubit;
      },
      act: (cubit) => cubit.loadLocations(),
      expect: () => [
        const LocationState(0).copyWith(homeStayPercent: 100),
      ],
    );

    blocTest<LocationCubit, LocationState>(
      'emits LocationState with homeStayPercent when onLocationUpdates is called',
      build: () {
        var mockLocations = [
          Location(
              longitude: 0,
              latitude: 0,
              isHome: true,
              timestamp: DateTime(2023, 11, 3, 6, 0, 0)),
        ];

        var mockInsertLocation = Location(
            longitude: 1.0,
            latitude: 1.0,
            isHome: false,
            timestamp: DateTime(2023, 11, 3, 12, 0, 0));

        when(() => locationRepository.getLocationsForDay(any()))
            .thenAnswer((_) async => mockLocations);
        when(() => locationRepository.insert(any())).thenAnswer((_) async {
          mockLocations.add(mockInsertLocation);
        });
        when(() => locationRepository.getLastest())
            .thenAnswer((_) async => mockLocations.first);

        SharedPreferences.setMockInitialValues(
            <String, Object>{'home_latitude': 0.0, 'home_longitude': 0.0});

        return locationCubit;
      },
      act: (cubit) {
        withClock(Clock.fixed(DateTime(2023, 11, 3, 12, 0, 0)), () {
          return cubit.onLocationUpdates(LocationDto.fromJson({
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
      },
      expect: () => [
        const LocationState(0).copyWith(homeStayPercent: 50.0),
      ],
    );
  });

  blocTest<LocationCubit, LocationState>(
    'emits LocationState with homeStayPercent when onLocationUpdates is called and no locations exists',
    build: () {
      List<Location> mockLocations = [];
      var mockInsertLocation = Location(
          longitude: 1.0,
          latitude: 1.0,
          isHome: false,
          timestamp: DateTime(2023, 11, 3, 12, 0, 0));

      when(() => locationRepository.getLocationsForDay(any()))
          .thenAnswer((_) async => mockLocations);
      when(() => locationRepository.insert(any())).thenAnswer((_) async {
        mockLocations.add(mockInsertLocation);
      });
      when(() => locationRepository.getLastest()).thenAnswer((_) async => null);

      SharedPreferences.setMockInitialValues(
          <String, Object>{'home_latitude': 0.0, 'home_longitude': 0.0});
      return locationCubit;
    },
    act: (cubit) => cubit.onLocationUpdates(
      LocationDto.fromJson({
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
      }),
    ),
    expect: () => [
      const LocationState(0).copyWith(homeStayPercent: 0.0),
    ],
  );

  blocTest<LocationCubit, LocationState>(
    'does not emit LocationState with homeStayPercent when onLocationUpdates is called and minimum interval between inserts is not reached',
    build: () {
      when(() => locationRepository.getLastest()).thenAnswer(
        (_) async => Location(
            longitude: 0,
            latitude: 0,
            isHome: true,
            timestamp: DateTime(2023, 11, 3, 11, 59, 0),
      ));
      return locationCubit;
    },
    act: (cubit) {
      withClock(Clock.fixed(DateTime(2023, 11, 3, 12, 0, 0)), () {
        return cubit.onLocationUpdates(
          LocationDto.fromJson({
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
          }),
        );
      });
    },
    expect: () => [],
    verify: (_) {
      verifyNever(() => locationRepository.insert(any()));
      verifyNever(() => locationRepository.getLocationsForDay(any()));
    },
  );

  blocTest<LocationCubit, LocationState>(
    'does not emit LocationState with homeStayPercent when onLocationUpdates is called and home location is not set',
    build: () {
      var date = DateTime.now();
      when(() => locationRepository.getLastest())
          .thenAnswer((_) async => Location(
                longitude: 0,
                latitude: 0,
                isHome: true,
                timestamp: date.subtract(const Duration(minutes: 15)),
              ));

      // Mock shared preferences with no home location
      SharedPreferences.setMockInitialValues(<String, Object>{});

      return locationCubit;
    },
    act: (cubit) => cubit.onLocationUpdates(
      LocationDto.fromJson({
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
      }),
    ),
    expect: () => [],
    verify: (_) {
      verifyNever(() => locationRepository.insert(any()));
      verifyNever(() => locationRepository.getLocationsForDay(any()));
    },
  );
}
