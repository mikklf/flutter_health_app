import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/domain/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/steps_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/weight_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStepRepository extends Mock implements IStepRepository {}
class MockWeightRepository extends Mock implements IWeightRepository {}

class DateTimeFake extends Fake implements DateTime {}

void main() {
  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace services with mocks
    services.unregister<IStepRepository>();
    services.registerSingleton<IStepRepository>(MockStepRepository());
    services.unregister<IWeightRepository>();
    services.registerSingleton<IWeightRepository>(MockWeightRepository());

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
    
    when(() => services<IWeightRepository>().getLatestWeights(any()))
        .thenAnswer((_) async {
      return [];
    });

  });

  tearDown(() {
    services.reset(dispose: true);
  });

  Widget createWidgetUnderTest() {
    return BlocProvider(
      create: (context) => SyncCubit(services.get<IStepRepository>()),
      child: const MaterialApp(
        title: 'Overview Screen Test',
        home: OverviewScreen(),
      ),
    );
  }

  testWidgets('Overview Screen has a StepsWidget', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.widgetWithText(StepsWidget, "Steps"), findsOneWidget);
  });

  testWidgets('Overview Screen has a WeightWidget', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.widgetWithText(WeightWidget, "Weight"), findsOneWidget);
  });
}
