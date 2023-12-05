import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_extraction/helpers/data_extractor_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/home_stay_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/weather_widget.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;

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
    return RefreshIndicator(
      onRefresh: context.read<SyncCubit>().syncAll,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // TESTING SHOULD BE REMOVED!
          const Text(
            "Debug buttons",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          Wrap(
            spacing: 4,
            children: [
              ElevatedButton(
                  onPressed: _healthHeartRateButtonPressed,
                  child: const Text("Add Heart rate")),
              ElevatedButton(
                  onPressed: _healthStepsButtonPressed,
                  child: const Text("Add Steps")),
              ElevatedButton(
                  onPressed: () {
                    _testPreprocessButtonPressed(context);
                  },
                  child: const Text("Test Preprocessing")),
              ElevatedButton(
                  onPressed: () async {
                    context.read<SetupCubit>().resetSetup();
                  },
                  child: const Text("Reset setup"))
            ],
          ),
          const Divider(),
          // Testing code end
    
          // Register widgets here
          const StepsWidget(),
          const WeightWidget(),
          const HomeStayWidget(),
          const HeartRateWidget(),
          const WeatherWidget(),
        ],
      ),
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

  /// TESTING SHOULD BE REMOVED!
  void _testPreprocessButtonPressed(BuildContext context) async {
    var processor = services.get<IDataExtractor>();

    var startTime = DateTime(2023, 1, 1);
    var endTime = DateTime.now();

    var csv = DataExtractorHelper.toCsv(
        await processor.getData(startTime, endTime));

    // 10.0.2.2 allows localhost to be accessed from emulator
    // If using Android Studio emulator with default settings.
    var url = "http://10.0.2.2:5000";
    var response = 
    await http.post(Uri.parse(url), body: csv, headers: {
      "Content-Type": "text/csv",
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: response.statusCode == 200
              ? const Text("OK 200: Data has been sent")
              : Text("Error: ${response.statusCode} ${response.body}"),
        ),
      );
    }
  }
}
