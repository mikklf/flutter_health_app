import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPermissionHandlerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PermissionHandlerPlatform {
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) =>
      Future.value(PermissionStatus.granted);
}

class MockGeocodingPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeocodingPlatform {
  @override
  Future<List<Location>> locationFromAddress(
    String address, {
    String? localeIdentifier,
  }) async {
    if (address == "") {
      throw const NoResultFoundException();
    } else {
      return [
        Location(
            latitude: 52.2165157,
            longitude: 6.9437819,
            timestamp: DateTime.fromMillisecondsSinceEpoch(0).toUtc())
      ];
    }
  }

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String? localeIdentifier,
  }) async {
    return [
      Placemark(
          administrativeArea: 'Overijssel',
          country: 'Netherlands',
          isoCountryCode: 'NL',
          locality: 'Enschede',
          name: 'Gronausestraat',
          postalCode: '',
          street: 'Gronausestraat 710',
          subAdministrativeArea: 'Enschede',
          subLocality: 'Enschmarke',
          subThoroughfare: '',
          thoroughfare: 'Gronausestraat')
    ];
  }
}

void main() {
  late SetupCubit setupCubit;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupCubit = SetupCubit();
    GeocodingPlatform.instance = MockGeocodingPlatform();
    PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
  });

  tearDown(() {
    setupCubit.close();
  });

  group('SetupCubit', () {
    test('initial state is correct', () {
      expect(setupCubit.state, const SetupState());
    });

    blocTest<SetupCubit, SetupState>(
      'emits isLocationPermissionGranted when checkLocationPermission is called',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.checkLocationPermission(),
      expect: () => [
        const SetupState(isLocationPermissionGranted: true),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isConsentGiven when checkConstentGiven is called',
      build: () {
        SharedPreferences.setMockInitialValues(
            <String, Object>{'consent_given': true});

        return SetupCubit();
      },
      act: (cubit) => cubit.checkConstentGiven(),
      expect: () => [
        const SetupState(isConsentGiven: true),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits homeAddress when checkHomeAddressSet is called',
      build: () {
        SharedPreferences.setMockInitialValues(
            <String, Object>{'home_address': "123 Main St"});
        return SetupCubit();
      },
      act: (cubit) => cubit.checkHomeAddressSet(),
      expect: () => [
        const SetupState(homeAddress: '123 Main St'),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isHealthPermissionGranted when checkHealthPermissionStatus is called',
      build: () {
        SharedPreferences.setMockInitialValues(
            <String, Object>{'health_permission_given': true});
        return SetupCubit();
      },
      act: (cubit) => cubit.checkHealthPermissionStatus(),
      expect: () => [
        const SetupState(isHealthPermissionGranted: true),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isSetupCompleted false when checkSetupStatus is called and not completed',
      build: () {
        SharedPreferences.setMockInitialValues(<String, Object>{
          'consent_given': false,
          'health_permission_given': true,
          'home_address': '123 Main St',
          'setup_completed': true,
        });
        return SetupCubit();
      },
      act: (cubit) {
        cubit.checkSetupStatus();
      },
      verify: (cubit) => expect(cubit.state.isSetupCompleted, false),
    );

    blocTest<SetupCubit, SetupState>(
      'emits isSetupCompleted when completeSetup is called',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.completeSetup(),
      expect: () => [
        const SetupState(isSetupCompleted: true),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isSetupCompleted when resetSetup is called',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.resetSetup(),
      expect: () => [
        const SetupState(isSetupCompleted: false),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isConsentGiven when saveConsent is called',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.saveConsent(RPTaskResult(identifier: "test")),
      expect: () => [
        const SetupState(isConsentGiven: true),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isHealthPermissionGranted when saveHealthPermission is called with success = true',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.saveHealthPermission(success: true),
      expect: () => [
        const SetupState(isHealthPermissionGranted: true),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits isHealthPermissionGranted when saveHealthPermission is called with success = false',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.saveHealthPermission(success: false),
      expect: () => [
        const SetupState(isHealthPermissionGranted: false),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits homeAddress when updateHomeAddress is called with valid address',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.updateHomeAddress("Gronausetraat 710"),
      expect: () => [
        const SetupState(
            homeAddress: "Gronausestraat 710,  Enschede, Netherlands"),
      ],
    );

    blocTest<SetupCubit, SetupState>(
      'emits "No location found" when updateHomeAddress is called with invalid address',
      build: () {
        return SetupCubit();
      },
      act: (cubit) => cubit.updateHomeAddress(""),
      expect: () => [
        const SetupState(homeAddress: "No location found"),
      ],
      verify: (cubit) => throwsA(isA<NoResultFoundException>),
    );
  });
}
