import 'package:flutter/material.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/steps_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStepRepository extends Mock implements IStepRepository {}

class DateTimeFake extends Fake implements DateTime {}

void main() {
  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();
    
    // Replace StepRepository with a mock
    services.unregister<IStepRepository>();
    services.registerSingleton<IStepRepository>(MockStepRepository());

    // Register fallback value for SurveyEntry
    registerFallbackValue(DateTimeFake());

    // Register mock behaviour
    when(() => services<IStepRepository>().getStepsInRange(any(), any()))
        .thenAnswer((_) async {
      return [];
    });
  });

  tearDown(() {
    services.reset(dispose: true);
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      title: 'Overview Screen Test',
      home: OverviewScreen(),
    );
  }

  testWidgets('Overview Screen has a text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.widgetWithText(StepsWidget, "Steps"), findsOneWidget);
  });
}
