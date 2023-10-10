import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';

void main() {
  // Register services
  ServiceLocator.setupDependencyInjection();

  // Run app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const List<Widget> pages = [
    OverviewScreen(),
    SurveyDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Check if setup has been done, perhaps using shared preferences

    var hasBeenSetup = true;


    if (hasBeenSetup) {
      return _buildHomeScreen();
    } else {
      return _buildSetupScreen();
    }
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
        home: HomeScreen(pages: pages),
      ),
  );
  }
}
