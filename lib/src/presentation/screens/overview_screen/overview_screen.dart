import 'package:flutter/material.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:health/health.dart';

import 'widgets/heartbeat_widget.dart';
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
        ElevatedButton(
            onPressed: _healthButtonPressed,
            child: const Text("Press me for health data")),
        const StepsWidget(),
        const HeartbeatWidget(),
        const WeightWidget(),
      ],
    );
  }

  void _healthButtonPressed() async {
    var stepRepository = services.get<IStepRepository>();

    //await stepRepository.updateStepsForDay(
    //    DateTime.now(), Random().nextInt(1000));

    HealthFactory healthFactory = await HealthHelper.getHealthFactory();

    var now = DateTime.now();
    var earlier = now.subtract(const Duration(minutes: 5));

    healthFactory.writeHealthData(500, HealthDataType.STEPS, earlier, now);

    var startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var databaseSteps = await stepRepository.getStepsInRange(startOfDay, endOfDay);

    var healthSteps = await HealthHelper.getSteps(startOfDay, endOfDay);



    debugPrint("Steps in DB for day: $databaseSteps");
    debugPrint("Steps in Health for day: $healthSteps");
  }
}
