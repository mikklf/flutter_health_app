import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/data_card_box_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

class MockHeartRateRepository extends Mock implements IHeartRateRepository {}

class MockStepRepository extends Mock implements IStepRepository {}

void main() {
  late SyncCubit syncCubit;

  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    services.unregister<IStepRepository>();
    services.registerSingleton<IStepRepository>(MockStepRepository());
    services.unregister<IHeartRateRepository>();
    services.registerSingleton<IHeartRateRepository>(MockHeartRateRepository());

    when(() => services<IStepRepository>().syncSteps(any()))
        .thenAnswer((_) async {});

    when(() => services<IHeartRateRepository>().syncHeartRates(any()))
        .thenAnswer((_) async {});

    SharedPreferences.setMockInitialValues(<String, Object>{});

    syncCubit = SyncCubit(
        services.get<IStepRepository>(), services.get<IHeartRateRepository>());
  });

  tearDown(() {
    services.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => syncCubit..syncAll(),
        child: const HeartRateWidget(),
      ),
    );
  }

  group('HeartRateWidget', () {
    testWidgets('renders DataCardBoxWidget', (WidgetTester tester) async {
      // Arrange
      when(() => services<IHeartRateRepository>()
          .getHeartRatesInRange(any(), any())).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(DataCardBoxWidget), findsOneWidget);
    });

    testWidgets('expect HeartRateWidget to show chart',
        (WidgetTester tester) async {
      // Arrange
      when(() => services<IHeartRateRepository>()
          .getHeartRatesInRange(any(), any())).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(charts.TimeSeriesChart), findsOneWidget);
    });

    testWidgets('expect HeartRateWidget to show synced heart rates',
        (WidgetTester tester) async {
      // Arrange
      final mockData = [
        HeartRate(
            beatsPerMinute: 70,
            timestamp: DateTime.utc(1969, 7, 20, 20, 18, 04))
      ];
      
      when(() => services<IHeartRateRepository>()
          .getHeartRatesInRange(any(), any())).thenAnswer((_) async => mockData);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("0 - 0 bpm"), findsOneWidget);
      await tester.pumpAndSettle();

      // Assert
      verify(() => services<IHeartRateRepository>().syncHeartRates(any()))
          .called(1);
      verify(() => services<IHeartRateRepository>()
              .getHeartRatesInRange(any(), any())).called(1);
      expect(find.text("70 - 70 bpm"), findsOneWidget);
    });
  });
}
