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
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Register services
  ServiceLocator.setupDependencyInjection();

  // Run app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future isSetupRequired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool setupCompleted = (prefs.getBool('setupCompleted') ?? false);
    return !setupCompleted;
  }

  @override
  Widget build(BuildContext context) {
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

    // Informed consent
    // Get relevant user data (Home location)
    // Mabye permissions

    return const MaterialApp(
      title: 'Setup screen',
      home: Scaffold(
        body: Center(
          child: Text('This is the setup screen'),
        ),
      ),
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
        create: (context) => SyncCubit(services.get<IStepRepository>())..syncAll(),
      ),
      BlocProvider(
        lazy: false,
        create: (context) => LocationCubit(services.get<ILocationRepository>())..startTracking(),
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
