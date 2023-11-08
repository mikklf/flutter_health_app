import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/location_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/step_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/survey_entry_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/weather_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/weight_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_location_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_step_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_weather_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_survey_entry_datacontext.dart';
import 'package:flutter_health_app/src/data/data_context/sqlite_weight_datacontext.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/sqlite_data_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/dataproviders/health_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/inmemory_survey_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/survey_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/open_weather_provider.dart';
import 'package:flutter_health_app/src/data/repositories/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/data/repositories/location_repository.dart';
import 'package:flutter_health_app/src/data/repositories/step_repository.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
import 'package:flutter_health_app/src/data/repositories/weather_repository.dart';
import 'package:flutter_health_app/src/data/repositories/weight_repository.dart';
import 'package:get_it/get_it.dart';

final services = GetIt.instance;

class ServiceLocator {
  static void setupDependencyInjection() {
    // Register services
    services.registerSingleton<IDatabaseHelper>(SqliteDatabaseHelper());

    services.registerSingleton<ISurveyProvider>(InMemorySurveyProvider());
    services
        .registerSingleton<ISurveyEntryDataContext>(SurveyEntryDataContext(services<IDatabaseHelper>()));
    services.registerSingleton<IHealthProvider>(HealthProvider());

    services.registerSingleton<ISurveyRepository>(SurveyRepository(
      services<ISurveyProvider>(),
      services<ISurveyEntryDataContext>(),
    ));

    services.registerSingleton<ISurveyEntryRepository>(SurveyEntryRepository(
      services<ISurveyEntryDataContext>(),
    ));

    services.registerSingleton<IStepDataContext>(StepDataContext(services<IDatabaseHelper>()));

    services.registerSingleton<IStepRepository>(StepRepository(
      services<IStepDataContext>(),
      services<IHealthProvider>(),
    ));

    services.registerSingleton<ILocationDataContext>(LocationDataContext(services<IDatabaseHelper>()));
    services.registerSingleton<ILocationRepository>(
        LocationRepository(services<ILocationDataContext>()));

    services.registerSingleton<IHeartRateDataContext>(HeartRateDataContext(services<IDatabaseHelper>()));
    services.registerSingleton<IHeartRateRepository>(HeartRateRepository(
      services<IHeartRateDataContext>(),
      services<IHealthProvider>(),
    ));

    services.registerSingleton<IWeightDataContext>(WeightDataContext(services<IDatabaseHelper>()));
    services.registerSingleton<IWeightRepository>(
        WeightRepository(services<IWeightDataContext>()));

    services.registerSingleton<IWeatherProvider>(OpenWeatherProvider());
    services.registerSingleton<IWeatherDataContext>(WeatherDataContext(
        services<IDatabaseHelper>()));
    services.registerSingleton<IWeatherRepository>(
        WeatherRepository(services<IWeatherDataContext>()));

    services.registerSingleton<IDataPreprocessor>(SqliteDataPreprocessor());

  }
}
