import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/constants.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/open_weather_provider.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/logic/location_cubit.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/logic/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/logic/weather_cubit.dart';
import 'package:flutter_health_app/src/presentation/home_screen.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/data_card_box_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_health_app/src/presentation/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../mock_database_helper.dart';

class MockHeartRateRepository extends Mock implements IHeartRateRepository {}

class MockStepRepository extends Mock implements IStepRepository {}

class MockHealthProvider extends Mock implements IHealthProvider {}

class MockOpenWeatherProvider extends Mock implements IWeatherProvider {}

void main() {
  late SyncCubit syncCubit;
  final mockHealthProvider = MockHealthProvider();
  final mockHeartRateDataContext = MockDatabaseHelper();
  final mockOpenWeatherProvider = MockOpenWeatherProvider();

  late Database db;

  setUp(() async {
    when(() => mockHealthProvider.getSteps(any(), any()))
        .thenAnswer((_) async => 0);

    // Register services
    ServiceLocator.setupDependencyInjection();

    services.unregister<IDatabaseHelper>();
    services.unregister<IHealthProvider>();
    services.unregister<IWeatherProvider>();

    services.registerFactory<IDatabaseHelper>(() => mockHeartRateDataContext);
    services.registerFactory<IHealthProvider>(() => mockHealthProvider);
    services.registerFactory<IWeatherProvider>(() => mockOpenWeatherProvider);

    db = await MockDatabaseHelper().getDatabase();

    SharedPreferences.setMockInitialValues(<String, Object>{});

    syncCubit = SyncCubit(
        services.get<IStepRepository>(), services.get<IHeartRateRepository>());
  });

  tearDown(() {
    db.close();
    services.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TabManagerCubit(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => SyncCubit(services.get<IStepRepository>(),
                services.get<IHeartRateRepository>())
              ..syncAll(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                LocationCubit(services.get<ILocationRepository>()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => WeatherCubit(
                services.get<IWeatherRepository>(),
                services.get<IWeatherProvider>()),
          ),
        ],
        child: MaterialApp(
          title: Constants.appName,
          home: const OverviewScreen(),
        ),
      ),
    );
  }

  group('Dashboard integration test', () {
    testWidgets('expect widgets on dashboard', (WidgetTester tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      // Arrange
      when(() => mockHealthProvider.getHeartbeats(any(), any()))
          .thenAnswer((_) async => [
                HealthDataPoint(
                    NumericHealthValue(70),
                    HealthDataType.HEART_RATE,
                    HealthDataUnit.BEATS_PER_MINUTE,
                    DateTime.now().subtract(const Duration(minutes: 5)),
                    DateTime.now().subtract(const Duration(seconds: 5)),
                    PlatformType.IOS,
                    'deviceId',
                    'sourceId',
                    'sourceName')
              ]);

      when(() => mockHealthProvider.getSteps(any(), any()))
          .thenAnswer((_) async => 2000);

      await tester.runAsync(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();
        expect(find.text("0 - 0 bpm", skipOffstage: false), findsOneWidget);

        // Act
        await syncCubit.syncAll();

        // Allow time for sync to complete
        await Future.delayed(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
      });

      // Assert
      expect(find.text("70 - 70 bpm", skipOffstage: false), findsOneWidget);
      expect(find.text("2000 steps today"), findsOneWidget);
    });
  });
}
