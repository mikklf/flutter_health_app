import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:flutter_health_app/src/logic/weather_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/presentation/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/location_cubit.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_health_app/src/logic/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/setup_screen.dart';
import 'package:flutter_health_app/src/presentation/survey_dashboard_screen/survey_dashboard_screen.dart';

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
            buildWhen: (previous, current) =>
                previous.isSetupCompleted != current.isSetupCompleted ||
                previous.isLoading != current.isLoading,
            builder: (_, state) {
              if (state.isLoading) {
                return MaterialApp(
                  title: Constants.appName,
                  home: const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

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
    // Setting interval only works on Android and is ignored on iOS, where location updates are determined by the OS.
    LocationManager().interval = 60 * 15; // 15 minutes
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = Constants.appName;
    LocationManager().notificationMsg =
        '${Constants.appName} is tracking your location';
    LocationManager().accuracy = LocationAccuracy.BALANCED;

    LocationManager().start();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TabManagerCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => SyncCubit(services.get<IStepRepository>(),
              services.get<IHeartRateRepository>())
            ..syncAll(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) =>
              LocationCubit(services.get<ILocationRepository>()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) =>
              WeatherCubit(services.get<IWeatherRepository>(), services.get<IWeatherProvider>()),
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
