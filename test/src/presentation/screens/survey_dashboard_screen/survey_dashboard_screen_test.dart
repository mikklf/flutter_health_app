import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/business_logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSurveyRepository extends Mock implements ISurveyRepository {}

void main() {
  group("SurveyDashboardScreen", () {
    setUpAll(() {
      // Register services
      ServiceLocator.setupDependencyInjection();

      // Replace SurveyRepository with a mock
      services.unregister<ISurveyRepository>();
      services.registerSingleton<ISurveyRepository>(MockSurveyRepository());
    });

    tearDownAll(() {
      services.reset(dispose: true);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
          title: 'survey dashboard test',
          home: BlocProvider(
            create: (context) => TabManagerCubit()..changeTab(1),
            child: const SurveyDashboardScreen(),
          ));
    }

    /// Test that the CircularProgressIndicator is shown when state.isLoading is true.
    /// Test that the "No surveys available" message is shown when there are no surveys.
    /// Test that the survey list is shown when there are surveys.
    /// Test that tapping on a survey card navigates to the SurveyScreen.

    testWidgets(
        'CircularProgressIndicator is shown when state.isLoading is true',
        (tester) async {
      when(() => services.get<ISurveyRepository>().getActive()).thenAnswer(
          (_) => Future.delayed(const Duration(seconds: 2), () => []));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      expect(find.text("No surveys available"), findsOneWidget);

      await tester.drag(find.text("No surveys available"), Offset(0, 500));

      await tester.pumpAndSettle();

      expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    });
  });
}
