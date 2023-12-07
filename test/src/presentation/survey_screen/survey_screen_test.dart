import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/logic/surveys_cubit.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/src/presentation/survey_screen/survey_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyEntryRepository extends Mock
    implements ISurveyEntryRepository {}

class RPTaskResultFake extends Fake implements RPTaskResult {}

void main() {
  setUpAll(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace SurveyRepository with a mock
    services.unregister<ISurveyEntryRepository>();
    services
        .registerSingleton<ISurveyEntryRepository>(MockSurveyEntryRepository());

    // Register fallback value for SurveyEntry
    registerFallbackValue(RPTaskResultFake());
  });

  tearDownAll(() {
    services.reset(dispose: true);
  });

  group("SurveyScreen", () {
    testWidgets('Survey screen pops when canceling survey', (tester) async {
      // Arrange
      await tester
          .pumpWidget(MaterialApp(home: SurveyScreen(survey: Surveys.kellner)));

      // Act
      // Press cross button
      await tester.tap(find.byIcon(Icons.highlight_off));
      await tester.pumpAndSettle();

      // Confirm cancel
      await tester.tap(find.text("YES"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SurveyScreen), findsNothing);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
          title: 'survey screen test',
          home: BlocProvider(
            create: (context) =>
                SurveysCubit(services.get<ISurveyRepository>(), services.get<ISurveyEntryRepository>()),
            child: SurveyScreen(survey: Surveys.dummy),
          ));
    }

    testWidgets('Survey screen pops when submitting', (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      when(() => services<ISurveyEntryRepository>().save(any(), any()))
          .thenAnswer((_) async => {});

      // Act
      // Press done button
      await tester.tap(find.text("DONE"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SurveyScreen), findsNothing);
      // Verify that save was called
      verify(() => services<ISurveyEntryRepository>().save(any(), any()))
          .called(1);
    });
  });
}
