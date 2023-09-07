import 'package:flutter/material.dart';
import 'package:flutter_health_app/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/survey_manager_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/survey_entry_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/survey_provider.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => SurveyRepository(
            SurveyProvider(),
            SurveyEntryProvider(),
          ),
        ),
        RepositoryProvider(
          create: (context) => SurveyEntryRepository(
            SurveyEntryProvider(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TabManagerCubit(),
          ),
          BlocProvider(
            create: (context) => SurveyManagerCubit(
              RepositoryProvider.of<SurveyEntryRepository>(context)
            ),
          ),
          BlocProvider(
            create: (context) => SurveysBloc(
              RepositoryProvider.of<SurveyRepository>(context)
            )..add(LoadSurveys()),
          ),
        ],
        child: const MaterialApp(
          title: 'Mobile Health Application',
          home: HomeScreen(),
        ),
      ),
    );
  }
}
