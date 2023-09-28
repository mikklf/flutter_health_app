import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/repositories/step_repository.dart';

import 'widgets/heartbeat_widget.dart';
import 'widgets/steps_widget.dart';
import 'widgets/weight_widget.dart';

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
    var stepRepository = services.get<StepRepository>();

    await stepRepository.updateStepsForDay(DateTime.now(), Random().nextInt(1000));

    var steps = await stepRepository.getStepsForDay(DateTime.now());

    debugPrint("Steps: $steps");
  }
}
