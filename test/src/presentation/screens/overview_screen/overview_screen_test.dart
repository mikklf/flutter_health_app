import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/weather_cubit.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/home_stay_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/steps_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/weather_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/weight_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStepRepository extends Mock implements IStepRepository {}

class MockHeartRateRepository extends Mock implements IHeartRateRepository {}

class MockWeightRepository extends Mock implements IWeightRepository {}

class MockLocationRepository extends Mock implements ILocationRepository {}

class MockWeatherRepository extends Mock implements IWeatherRepository {}

class DateTimeFake extends Fake implements DateTime {}

void main() {
  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace services with mocks
    services.unregister<IStepRepository>();
    services.registerSingleton<IStepRepository>(MockStepRepository());
    services.unregister<IHeartRateRepository>();
    services.registerSingleton<IHeartRateRepository>(MockHeartRateRepository());
    services.unregister<IWeightRepository>();
    services.registerSingleton<IWeightRepository>(MockWeightRepository());
    services.unregister<ILocationRepository>();
    services.registerSingleton<ILocationRepository>(MockLocationRepository());
    services.unregister<IWeatherRepository>();
    services.registerSingleton<IWeatherRepository>(MockWeatherRepository());

    // Register fallback value for SurveyEntry
    registerFallbackValue(DateTimeFake());

    // Register mock behaviour
    when(() => services<IStepRepository>().getStepsInRange(any(), any()))
        .thenAnswer((_) async {
      return [];
    });
    
    when(() => services<IStepRepository>().syncSteps(any()))
        .thenAnswer((_) async {
      return;
    });

    when(() => services<IHeartRateRepository>().syncHeartRates(any()))
        .thenAnswer((_) async {
      return;
    });

    when(() => services<ILocationRepository>().getLocationsForDay(any()))
        .thenAnswer((_) async {
      return [];
    });

    when(() => services<IWeightRepository>().getLatestWeights(any()))
        .thenAnswer((_) async {
      return [];
    });

    when(() => services<IWeatherRepository>().getLastest())
        .thenAnswer((_) async {
      return;
    });

  });

  tearDown(() {
    services.reset(dispose: true);
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SyncCubit(services.get<IStepRepository>(), services.get<IHeartRateRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              LocationCubit(services.get<ILocationRepository>()),
        ),
        BlocProvider(
          create: (context) => WeatherCubit(services.get<IWeatherRepository>()),
        )
      ],
      child: const MaterialApp(
        title: 'Overview Screen Test',
        home: OverviewScreen(),
      ),
    );
  }

  group("OverviewScreen", () {
    testWidgets('Overview Screen has a StepsWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.scrollUntilVisible(find.byType(StepsWidget), 100);

      expect(find.byType(StepsWidget), findsOneWidget);
    });

    testWidgets('Overview Screen has a WeightWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.scrollUntilVisible(find.byType(WeightWidget), 100);

      expect(find.byType(WeightWidget), findsOneWidget);
    });

    testWidgets('Overview Screen has a HomeStayWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.scrollUntilVisible(find.byType(HomeStayWidget), 100);

      expect(find.byType(HomeStayWidget), findsOneWidget);
    });

    testWidgets('Overview Screen has a HeartRateWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.scrollUntilVisible(find.byType(HeartRateWidget), 100);

      expect(find.byType(HeartRateWidget), findsOneWidget);
    });

    testWidgets('Overview Screen has a WeatherWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.scrollUntilVisible(find.byType(WeatherWidget), 100);

      expect(find.byType(WeatherWidget), findsOneWidget);
    });
  });
}
