import 'package:flutter/material.dart';
import 'package:flutter_health_app/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/inmemory_survey_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/sqlite_survey_entry_provider.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
import 'package:get_it/get_it.dart';

import 'domain/interfaces/survey_entry_provider.dart';
import 'domain/interfaces/survey_entry_repository.dart';
import 'domain/interfaces/survey_provider.dart';
import 'domain/interfaces/survey_repository.dart';

final services = GetIt.instance;

void main() {

  // Register services
  services.registerSingleton<ISurveyProvider>(InMemorySurveyProvider());
  services.registerSingleton<ISurveyEntryProvider>(SQLiteSurveyEntryProvider());

  services.registerSingleton<ISurveyRepository>(SurveyRepository(
    services<ISurveyProvider>(),
    services<ISurveyEntryProvider>(),
  ));

  services.registerSingleton<ISurveyEntryRepository>(SurveyEntryRepository(
    services<ISurveyEntryProvider>(),
  ));

  // Run app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TabManagerCubit(),
          ),
        ],
        child: const MaterialApp(
          title: 'Mobile Health Application',
          home: HomeScreen(),
        ),
      );
  }
}
