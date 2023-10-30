import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_provider.dart';
import 'package:flutter_health_app/domain/interfaces/step_provider.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/domain/interfaces/survey_entry_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/domain/interfaces/survey_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/domain/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/data/dataproviders/health_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/inmemory_survey_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/sqlite_heart_rate_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/sqlite_location_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/sqlite_survey_entry_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/sqlite_step_provider.dart';
import 'package:flutter_health_app/src/data/repositories/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/location_repository.dart';
import 'package:flutter_health_app/src/data/repositories/step_repository.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
import 'package:flutter_health_app/src/data/repositories/weight_repository.dart';
import 'package:get_it/get_it.dart';

import 'domain/interfaces/heart_rate_repository.dart';
import 'domain/interfaces/location_provider.dart';
import 'domain/interfaces/location_repository.dart';

final services = GetIt.instance;

class ServiceLocator {
  static void setupDependencyInjection() {
    // Register services
    services.registerSingleton<ISurveyProvider>(InMemorySurveyProvider());
    services
        .registerSingleton<ISurveyEntryProvider>(SQLiteSurveyEntryProvider());
    services.registerSingleton<IHealthProvider>(HealthProvider());

    services.registerSingleton<ISurveyRepository>(SurveyRepository(
      services<ISurveyProvider>(),
      services<ISurveyEntryProvider>(),
    ));

    services.registerSingleton<ISurveyEntryRepository>(SurveyEntryRepository(
      services<ISurveyEntryProvider>(),
    ));

    services.registerSingleton<IStepProvider>(SqliteStepProvider());

    services.registerSingleton<IStepRepository>(StepRepository(
      services<IStepProvider>(),
      services<IHealthProvider>(),
    ));

    services.registerSingleton<ILocationProvider>(SqliteLocationProvider());
    services.registerSingleton<ILocationRepository>(
        LocationRepository(services<ILocationProvider>()));

    services.registerSingleton<IWeightRepository>(WeightRepository());

    services.registerSingleton<IHeartRateProvider>(SqliteHeartRateProvider());
    services.registerSingleton<IHeartRateRepository>(HeartRateRepository(
      services<IHeartRateProvider>(),
      services<IHealthProvider>(),
    ));
  }
}
