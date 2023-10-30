import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/steps_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:shared_preferences/shared_preferences.dart';

class MockStepRepository extends Mock implements IStepRepository {}
class MockHeartRateRepository extends Mock implements IHeartRateRepository {}

void main() {
  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    services.unregister<IStepRepository>();
    services.registerSingleton<IStepRepository>(MockStepRepository());
    services.unregister<IHeartRateRepository>();
    services.registerSingleton<IHeartRateRepository>(MockHeartRateRepository());

    when(() => services<IStepRepository>().syncSteps(any()))
        .thenAnswer((_) async {
      return;
    });
    
    when(() => services<IHeartRateRepository>().syncHeartRates(any()))
        .thenAnswer((_) async {
      return;
    });

    when(() => services<IStepRepository>().getStepsInRange(any(), any()))
        .thenAnswer((_) async => [Steps(date: DateTime.now(), steps: 100)]);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'lastSyncStepsDateTime':
          DateTime.now().subtract(const Duration(hours: 1)).toString()
    });
  });

  tearDown(() {
    services.reset(dispose: true);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
        home: BlocProvider(
            lazy: false,
            create: (_) =>
                SyncCubit(services.get<IStepRepository>(), services.get<IHeartRateRepository>())..syncAll(),
            child: const StepsWidget()));
  }

  group("StepsWidget", () {
    testWidgets('Expect StepsWidget to show chart', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(charts.BarChart), findsOneWidget);
    });

    testWidgets('Expect StepsWidget to show synced steps', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("0 steps today"), findsOneWidget);
      await tester.pumpAndSettle();

      // Assert
      verify(() => services<IStepRepository>().syncSteps(any())).called(1);
      verify(() => services<IStepRepository>().getStepsInRange(any(), any()))
          .called(1);
      expect(find.text("100 steps today"), findsOneWidget);
    });
  });
}
