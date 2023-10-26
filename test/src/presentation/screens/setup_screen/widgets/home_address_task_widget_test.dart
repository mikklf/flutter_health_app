import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/widgets/home_address_task_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/widgets/setup_task_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:research_package/research_package.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeocodingPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeocodingPlatform {
  @override
  Future<List<Location>> locationFromAddress(
    String address, {
    String? localeIdentifier,
  }) async {
    if (address == "invalid address") {
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
    setupCubit = SetupCubit();
    GeocodingPlatform.instance = MockGeocodingPlatform();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
        home: BlocProvider<SetupCubit>(
      create: (context) => setupCubit,
      child: const HomeAddressTaskWidget(),
    ));
  }

  group("ConsentTaskWidget", () {
    testWidgets('Expect HomeAddressTaskWidget to contain a SetupTaskWidget',
        (tester) async {

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SetupTaskWidget), findsOneWidget);
    });

    testWidgets('Expect onPressed to navigate to Home Address Survey',
        (tester) async {

      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(RPUITask), findsOneWidget);
    });

    testWidgets(
        'Expect widget to show success when completing Home Address task',
        (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues(<String, Object>{});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), "123 main street");
      await tester.pumpAndSettle();
      await tester.tap(find.text("NEXT"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Expect widget to remain uncompleted when providing invalid address',
        (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues(<String, Object>{});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), "invalid address");
      await tester.pumpAndSettle();
      await tester.tap(find.text("NEXT"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

  });
}
