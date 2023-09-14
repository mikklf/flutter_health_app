import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/domain/surveys/surveys.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_screen/survey_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyEntryRepository extends Mock implements ISurveyEntryRepository {}

class RPTaskResultFake extends Fake implements RPTaskResult {}

void main() {
  setUpAll(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace SurveyRepository with a mock
    services.unregister<ISurveyEntryRepository>();
    services.registerSingleton<ISurveyEntryRepository>(MockSurveyEntryRepository());

    // Register fallback value for SurveyEntry
    registerFallbackValue(RPTaskResultFake());
  });

  tearDownAll(() {
    services.reset(dispose: true);
  });

  testWidgets('Survey screen pops when canceling survey', (tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(
        home: SurveyScreen(survey: Survey.fromRPSurvey(Surveys.kellner))));

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

  testWidgets('Survey screen pops when submitting', (tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(
        home: SurveyScreen(survey: Survey.fromRPSurvey(Surveys.dummy))));

    when(() => services<ISurveyEntryRepository>().save(any(), any()))
        .thenAnswer((_) async => {});

    // Act
    // Press done button
    await tester.tap(find.text("DONE"));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(SurveyScreen), findsNothing);
    // Verify that save was called
    verify(() => services<ISurveyEntryRepository>().save(any(), any())).called(1);
  });
}
