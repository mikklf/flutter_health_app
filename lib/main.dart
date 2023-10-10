import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/setup_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ServiceLocator.setupDependencyInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  final bool skipSetup;

  const MainApp({super.key, this.skipSetup = false});

  Future isSetupRequired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool setupCompleted = (prefs.getBool('setupCompleted') ?? false);
    return !setupCompleted;
  }

  @override
  Widget build(BuildContext context) {
    if (skipSetup) {
      return _buildHomeScreen();
    }

    return FutureBuilder(
      future: isSetupRequired(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return _buildSetupScreen();
          } else {
            return _buildHomeScreen();
          }
        } else {
          return const MaterialApp(
            title: 'Mobile Health Application',
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
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
