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
import 'package:flutter_health_app/src/data/data_preprocessing/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/heart_rate_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/location_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/steps_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/survey_result_preprocessor/kellner_result_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/weather_preprocessor.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/weight_preprocessor.dart';
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
    services.registerFactory<IDatabaseHelper>(() => SqliteDatabaseHelper());

    services.registerFactory<ISurveyProvider>(() => InMemorySurveyProvider());
    services.registerFactory<ISurveyEntryDataContext>(
        () => SurveyEntryDataContext(services<IDatabaseHelper>()));
    services.registerFactory<IHealthProvider>(() => HealthProvider());

    services.registerFactory<ISurveyRepository>(() => SurveyRepository(
          services<ISurveyProvider>(),
          services<ISurveyEntryDataContext>(),
        ));

    services
        .registerFactory<ISurveyEntryRepository>(() => SurveyEntryRepository(
              services<ISurveyEntryDataContext>(),
            ));

    services.registerFactory<IStepDataContext>(
        () => StepDataContext(services<IDatabaseHelper>()));

    services.registerFactory<IStepRepository>(() => StepRepository(
          services<IStepDataContext>(),
          services<IHealthProvider>(),
        ));

    services.registerFactory<ILocationDataContext>(
        () => LocationDataContext(services<IDatabaseHelper>()));
    services.registerFactory<ILocationRepository>(
        () => LocationRepository(services<ILocationDataContext>()));

    services.registerFactory<IHeartRateDataContext>(
        () => HeartRateDataContext(services<IDatabaseHelper>()));
    services.registerFactory<IHeartRateRepository>(() => HeartRateRepository(
          services<IHeartRateDataContext>(),
          services<IHealthProvider>(),
        ));

    services.registerFactory<IWeightDataContext>(
        () => WeightDataContext(services<IDatabaseHelper>()));
    services.registerFactory<IWeightRepository>(
        () => WeightRepository(services<IWeightDataContext>()));

    services.registerFactory<IWeatherProvider>(() => OpenWeatherProvider());
    services.registerFactory<IWeatherDataContext>(
        () => WeatherDataContext(services<IDatabaseHelper>()));
    services.registerFactory<IWeatherRepository>(
        () => WeatherRepository(services<IWeatherDataContext>()));

    services.registerFactory<IDataPreprocessor>(() => DataPreprocessor([
          HeartRatePreprocessor(services<IDatabaseHelper>()),
          LocationPreprocessor(services<IDatabaseHelper>()),
          StepsPreprocessor(services<IDatabaseHelper>()),
          WeatherPreprocessor(services<IDatabaseHelper>()),
          WeightPreprocessor(services<IDatabaseHelper>()),
          KellnerResultPreprocessor(services<IDatabaseHelper>()),
        ]));
  }
}
