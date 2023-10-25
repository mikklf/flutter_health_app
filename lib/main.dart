import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/setup_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';

import 'constants.dart';

void main() {
  ServiceLocator.setupDependencyInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SetupCubit()..checkSetupStatus(),
        child: BlocBuilder<SetupCubit, SetupState>(
          buildWhen: (previous, current) => previous.isSetupCompleted != current.isSetupCompleted,
          builder: (_, state) {
          debugPrint("Main rebuild");
          if (state.isSetupCompleted) {
            return _buildHomeScreen();
          } else {
            return _buildSetupScreen();
          }
        }));
  }

  Widget _buildSetupScreen() {
    return const MaterialApp(
      title: 'Setup screen',
      home: SetupScreen(),
    );
  }

  Widget _buildHomeScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TabManagerCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) =>
              SyncCubit(services.get<IStepRepository>())..syncAll(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) =>
              LocationCubit(services.get<ILocationRepository>())
                ..startTracking(),
        ),
      ],
      child: MaterialApp(
        title: Constants.appName,
        home: const HomeScreen(pages: [
          OverviewScreen(),
          SurveyDashboardScreen(),
        ]),
      ),
    );
  }
}
