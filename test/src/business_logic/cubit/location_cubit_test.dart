import 'package:bloc_test/bloc_test.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter_health_app/src/logic/cubit/location_cubit.dart';
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
                    timestamp: DateTime.now(),
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

    var mockLocations = [
      Location(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      )
    ];

    var mockLocation = Location(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
    );

    blocTest<LocationCubit, LocationState>(
      'emits LocationState with homeStayPercent when onLocationUpdates is called',
      build: () {
        when(() => locationRepository.getLocationsForDay(any()))
            .thenAnswer((_) async => mockLocations);
        when(() => locationRepository.insert(any())).thenAnswer((_) async {
          mockLocations.add(mockLocation);
          return true;
        });

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
        const LocationState(0).copyWith(homeStayPercent: 100),
      ],
    );
  });
}
