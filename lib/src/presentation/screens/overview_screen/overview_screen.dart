import 'package:flutter/material.dart';
import 'package:health/health.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    this.color = const Color(0xFF2DBD3A),
    this.child,
  });

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            HealthFactory health =
                HealthFactory(useHealthConnectIfAvailable: true);

            var types = [
              HealthDataType.STEPS,
            ];

            bool requested = await health.requestAuthorization(types);

            var now = DateTime.now();

            // fetch health data from the last 24 hours
            List<HealthDataPoint> healthData =
                await health.getHealthDataFromTypes(
                    now.subtract(Duration(days: 1)), now, types);

            // request permissions to write steps and blood glucose
            types = [HealthDataType.STEPS];
            var permissions = [
              HealthDataAccess.READ_WRITE
            ];
            await health.requestAuthorization(types, permissions: permissions);

            // write steps and blood glucose
            bool success = await health.writeHealthData(
                10, HealthDataType.STEPS, now, now);

            // get the number of steps for today
            var midnight = DateTime(now.year, now.month, now.day);
            int? steps = await health.getTotalStepsInInterval(midnight, now);

            print("Steps: $steps");
          },
          child: const Text("Press me")),
    );
  }
}
