import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/home_stay_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationRepository extends Mock implements ILocationRepository {}

void main() {
  group('WeightWidget', () {
    late ILocationRepository locationRepository;
    late LocationCubit locationCubit;

    setUp(() {
      locationRepository = MockLocationRepository();
      locationCubit = LocationCubit(locationRepository);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider(
          create: (context) => locationCubit,
          child: const HomeStayWidget(),
        ),
      );
    }

    testWidgets('Expect HomeStayWidget text when no locations exists',
        (tester) async {
      // Arrange
      when(() => locationRepository.getLocationsForDay(any()))
          .thenAnswer((_) async => []);    

      SharedPreferences.setMockInitialValues(
          <String, Object>{'home_latitude': 0.0, 'home_longitude': 0.0});

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      verify(() => locationRepository.getLocationsForDay(any())).called(1);
      expect(find.text(".. %"), findsOneWidget);
    });

    testWidgets('Expect HomeStayWidget text when locations exists',
        (tester) async {
      // Arrange
      when(() => locationRepository.getLocationsForDay(any()))
          .thenAnswer((_) async => [
                Location(
                  longitude: 0,
                  latitude: 0,
                  date: DateTime.now().subtract(const Duration(hours: 1)),
                )
          ]);    

      SharedPreferences.setMockInitialValues(
          <String, Object>{'home_latitude': 0.0, 'home_longitude': 0.0});

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      verify(() => locationRepository.getLocationsForDay(any())).called(1);
      expect(find.text("100 %"), findsOneWidget);
    });
  });
}
