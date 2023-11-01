import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_screen/survey_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockISurveyRepository extends Mock implements ISurveyRepository {}

void main() {
    late TabManagerCubit tabManagerCubit;

    setUp(() {
      // Register services
      ServiceLocator.setupDependencyInjection();

      // Replace SurveyRepository with a mock
      services.unregister<ISurveyRepository>();
      services.registerSingleton<ISurveyRepository>(MockISurveyRepository());
      tabManagerCubit = TabManagerCubit();
    });

    tearDown(() {
      services.reset(dispose: true);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
          title: 'survey dashboard test',
          home: BlocProvider(
            create: (context) => tabManagerCubit,
            child: const SurveyDashboardScreen(),
          ));
    }

  group("SurveyDashboardScreen", () {
    testWidgets('Loading indicator is displayed while waiting of Surveys',
        (tester) async {
      // arrange
      when(() => services<ISurveyRepository>().getActive())
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return [Surveys.kellner];
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // act
      tabManagerCubit.changeTab(1);

      await tester.pump(const Duration(milliseconds: 500));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      verify(() => services<ISurveyRepository>().getActive()).called(1);
    });

    testWidgets('No surveys available - displays appropriate message',
        (tester) async {
      // Arrange
      when(() => services<ISurveyRepository>().getActive())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      tabManagerCubit.changeTab(1);

      await tester.pumpAndSettle();

      // assert
      expect(find.text("No surveys available"), findsOneWidget);
      verify(() => services<ISurveyRepository>().getActive()).called(1);
    });

    testWidgets('Survey list - displays survey cards',
        (tester) async {
      // Arrange
      when(() => services<ISurveyRepository>().getActive())
          .thenAnswer((_) async => [Surveys.dummy]);

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      tabManagerCubit.changeTab(1);

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(SurveyCard), findsOneWidget);
      verify(() => services<ISurveyRepository>().getActive()).called(1);
    });

    testWidgets(
        'Pull to refresh - displays loading indicator and then survey list',
        (tester) async {
      // Arrange
      when(() => services.get<ISurveyRepository>().getActive()).thenAnswer(
          (_) async => await Future.delayed(const Duration(milliseconds: 500),
              () => [Surveys.dummy]));

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pump();

      // Assert
      expect(
          tester.getSemantics(find.byType(RefreshProgressIndicator)),
          matchesSemantics(
            label: 'Refresh',
          ));

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text("No surveys available"), findsNothing);
      expect(find.byType(SurveyCard), findsOneWidget);
    });

    testWidgets("Clicking survey card opens survey page", (tester) async {
      // Arrange
      when(() => services.get<ISurveyRepository>().getActive())
          .thenAnswer((_) async => [Surveys.dummy]);

      await tester.pumpWidget(createWidgetUnderTest());
      tabManagerCubit.changeTab(1);
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(SurveyCard));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.byType(SurveyScreen), findsOneWidget);
      
      verify(() => services.get<ISurveyRepository>().getActive()).called(1);
    });

    testWidgets("Return from survey updates survey list", (tester) async {
      // Arrange
      when(() => services.get<ISurveyRepository>().getActive())
          .thenAnswer((_) async => [Surveys.dummy]);

      await tester.pumpWidget(createWidgetUnderTest());
      tabManagerCubit.changeTab(1);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SurveyCard));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.highlight_off));
      await tester.pumpAndSettle();
      
      // Act
      await tester.tap(find.text("YES"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SurveyDashboardScreen), findsOneWidget);

      verify(() => services.get<ISurveyRepository>().getActive()).called(2);
    });
    
  });
}
