import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/home_stay_widget.dart';
import 'package:health/health.dart';

import 'widgets/steps_widget.dart';
import 'widgets/weight_widget.dart';

// TESTING SHOULD BE REMOVED!
import 'package:flutter_health_app/src/data/dataproviders/helpers/health_helper.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // TESTING SHOULD BE REMOVED!
        Row(
          children: [
            ElevatedButton(
                onPressed: _healthHeartRateButtonPressed,
                child: const Text("Test Heart rate")),
            ElevatedButton(
                onPressed: _healthStepsButtonPressed,
                child: const Text("Test Steps")),
            ElevatedButton(
                onPressed: () async {
                  context.read<SetupCubit>().resetSetup();
                },
                child: const Text("Reset setup"))
          ],
        ),

        // Register widgets here
        const StepsWidget(),
        const WeightWidget(),
        const HomeStayWidget(),
        const HeartRateWidget(),
      ],
    );
  }

  /// TESTING SHOULD BE REMOVED!
  void _healthStepsButtonPressed() async {
    var stepRepository = services.get<IStepRepository>();

    HealthFactory healthFactory = await HealthHelper.getHealthFactory();

    var now = DateTime.now();
    var earlier = now.subtract(const Duration(minutes: 5));

    healthFactory.writeHealthData(500, HealthDataType.STEPS, earlier, now);

    var startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var databaseSteps =
        await stepRepository.getStepsInRange(startOfDay, endOfDay);

    var stepsInDb = databaseSteps.isNotEmpty ? databaseSteps.first.steps : 0;

    var healthProvider = services.get<IHealthProvider>();
    var healthSteps = await healthProvider.getSteps(startOfDay, endOfDay);

    debugPrint("Steps in DB for day: $stepsInDb");
    debugPrint("Steps in Health for day: $healthSteps");
  }

  /// TESTING SHOULD BE REMOVED!
  void _healthHeartRateButtonPressed() async {
    var heartRateRepository = services.get<IHeartRateRepository>();

    HealthFactory healthFactory = await HealthHelper.getHealthFactory();

    var now = DateTime.now();

    healthFactory.writeHealthData(
        80, HealthDataType.HEART_RATE, DateTime.now(), DateTime.now());

    var startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var databaseHeartRate =
        await heartRateRepository.getHeartRatesInRange(startOfDay, endOfDay);

    var healthProvider = services.get<IHealthProvider>();
    var healthHeartRate =
        await healthProvider.getHeartbeats(startOfDay, endOfDay);

    var countDb = databaseHeartRate.length;
    var countHealth = healthHeartRate.length;

    debugPrint("Heart rate count in DB for day: $countDb");
    debugPrint("Heart rate count in Health for day: $countHealth");
  }
}
