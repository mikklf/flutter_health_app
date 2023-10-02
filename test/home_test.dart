import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/home.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSurveyRepository extends Mock implements ISurveyRepository {}

class MockStepRepository extends Mock implements IStepRepository {}

class DateTimeFake extends Fake implements DateTime {}

void main() {
  setUpAll(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace SurveyRepository with a mock
    services.unregister<ISurveyRepository>();
    services.registerSingleton<ISurveyRepository>(MockSurveyRepository());
    // Replace StepRepository with a mock
    services.unregister<IStepRepository>();
    services.registerSingleton<IStepRepository>(MockStepRepository());

    // Register fallback value for SurveyEntry
    registerFallbackValue(DateTimeFake());

    // Setup mock behaviour
    when(() => services<IStepRepository>().getStepsInRange(any(), any()))
        .thenAnswer((_) async {
      return [];
    });
  });

  tearDownAll(() {
    services.reset(dispose: true);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
        title: 'home Test',
        home: BlocProvider(
          create: (context) => TabManagerCubit(),
          child: const HomeScreen(),
        ));
  }

  testWidgets('Expect App bar', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Expect Bottom navigation bar with two items', (tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    var navbar = find.byType(BottomNavigationBar);
    final BottomNavigationBar bottomNavBar =
        tester.widget(find.byType(BottomNavigationBar));

    // Assert
    expect(navbar, findsOneWidget);
    expect(bottomNavBar.items.length, 2);
  });

  testWidgets('Initial selected tab is 0 and home page is OverviewScreen',
      (tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    final BottomNavigationBar bottomNavBar =
        tester.widget(find.byType(BottomNavigationBar));

    // Assert
    expect(bottomNavBar.currentIndex, 0);
    expect(find.byType(OverviewScreen), findsOneWidget);
    expect(find.byType(SurveyDashboardScreen), findsNothing);
  });

  testWidgets('Expect IndexedStack with two childrens', (tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    expect(find.byType(IndexedStack), findsOneWidget);
    final IndexedStack indexedStack = tester.widget(find.byType(IndexedStack));
    expect(indexedStack.index, 0);
    expect(indexedStack.children.length, 2);
  });

  testWidgets("Tapping survey page should change page", (tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    when(() => services<ISurveyRepository>().getActive())
        .thenAnswer((_) async => []);

    // Act
    await tester.tap(find.byIcon(Icons.book));
    await tester.pump();

    // Assert
    expect(find.byType(OverviewScreen), findsNothing);
    expect(find.byType(SurveyDashboardScreen), findsOneWidget);

    verify(() => services<ISurveyRepository>().getActive()).called(1);

    final BottomNavigationBar bottomNavBar =
        tester.widget(find.byType(BottomNavigationBar));
    expect(bottomNavBar.currentIndex, 1);
  });
}
