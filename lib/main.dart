import 'package:flutter/material.dart';
import 'package:flutter_health_app/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';

void main() {
  // Register services
  ServiceLocator.setupDependencyInjection();

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
