import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/main_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/setup_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';

void main() {
  ServiceLocator.setupDependencyInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainCubit()..initializeMainState(),
        child: BlocBuilder<MainCubit, MainState>(builder: (context, state) {
          if (state is InitialMainState) {
            return const CircularProgressIndicator();
          } else if (state is SetupRequiredState) {
            return _buildSetupScreen();
          } else {
            return _buildHomeScreen();
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
      child: const MaterialApp(
        title: 'Mobile Health Application',
        home: HomeScreen(pages: [
          OverviewScreen(),
          SurveyDashboardScreen(),
        ]),
      ),
    );
  }
}
