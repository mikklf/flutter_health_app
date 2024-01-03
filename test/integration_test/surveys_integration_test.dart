import 'package:clock/clock.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/logic/surveys_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../in_memory_database_helper.dart';

void main() {
  late Database db;
  late SurveysCubit surveysCubit;

  setUp(() async {
    ServiceLocator.setupDependencyInjection();

    db = await InMemoryDatabaseHelper().getDatabase();

    services.unregister<IDatabaseHelper>();
    services.registerFactory<IDatabaseHelper>(() => InMemoryDatabaseHelper());

    surveysCubit = SurveysCubit(services.get<ISurveyRepository>());
  });

  tearDown(() {
    db.close();
    services.reset();
  });

  group('Surveys integration test', () {
    test('save and load zero active surveys from database', () async {
      // Arrange
      await services
          .get<ISurveyRepository>()
          .saveEntry(RPTaskResult(identifier: "kellner"), "kellner");

      // Act
      await surveysCubit.loadSurveys();

      // Assert
      expect(surveysCubit.state.activeSurveys.length, 0);
    });

    test('save and load one active surveys from database', () async {
      // Arrange
      await withClock(Clock.fixed(DateTime(2021, 1, 1, 1, 0, 0)), () async {
        await services
            .get<ISurveyRepository>()
            .saveEntry(RPTaskResult(identifier: "kellner"), "kellner");
      });

      // Act
      await surveysCubit.loadSurveys();

      // Assert
      expect(surveysCubit.state.activeSurveys.length, 1);
    });
  });
}
