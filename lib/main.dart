import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:path/path.dart';

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
          BlocProvider(
            create: (context) => SyncCubit(services.get<IStepRepository>()),
          ),
        ],
        child: syncWidget(
          child: const MaterialApp(
            title: 'Mobile Health Application',
            home: HomeScreen(),
          ),
        ),
      );
  }
  
  /// Widget handles syncing sensor data with backend
  syncWidget({required MaterialApp child}) {
    return BlocBuilder<SyncCubit, SyncState>(
      builder: (context, state) {

        context.read<SyncCubit>().syncAll();

        return child;
      },
    );
  }
}
  