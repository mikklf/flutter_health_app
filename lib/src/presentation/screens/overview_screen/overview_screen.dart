import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:health/health.dart';

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
            onPressed: () async {
              
              HealthFactory health;
              
              // Due to a bug using Health Connect on Andriod SDK 34+ is not possible
              // See https://github.com/cph-cachet/flutter-plugins/issues/800
              // We therefore use Health Connect on Android SDK 33 and below
              // and use soon-to-be-deprecated Google Fit API on SDK 34 and above
              if (Platform.isIOS) {
                health = HealthFactory();
              } else {
                final deviceInfo = DeviceInfoPlugin();
                final androidInfo = await deviceInfo.androidInfo;

                if (androidInfo.version.sdkInt >= 34) {
                  health = HealthFactory();
                } else {
                  health = HealthFactory(useHealthConnectIfAvailable: true);
                }
              }

              var types = [
                HealthDataType.STEPS,
              ];

              var permission = [HealthDataAccess.READ_WRITE];

              bool requested = await health.requestAuthorization(types,
                  permissions: permission);

              var earlier = DateTime.now().subtract(Duration(minutes: 20));
              var now = DateTime.now();

              bool success = await health.writeHealthData(
                  150, HealthDataType.STEPS, earlier, now);

              var midnight = DateTime(now.year, now.month, now.day);
              int? steps = await health.getTotalStepsInInterval(midnight, now);

              print("Steps: $steps");
            },
            child: const Text("Press me for health data")),
        SizedBox(
            height: 250,
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Steps",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text("10320 steps today",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const Icon(Icons.directions_walk),
                    ],
                  ),
                  Expanded(
                    child: SimpleBarChart.withRandomData(),
                  ),
                ]),
              ),
            )),
        SizedBox(
            height: 250,
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Heatbeat",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text("87 bpm",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const Icon(Icons.heart_broken),
                    ],
                  ),
                  Expanded(
                    child: SimpleBarChart.withRandomData(),
                  ),
                ]),
              ),
            )),
        SizedBox(
            height: 250,
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Weight",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text("81 kg",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const Icon(Icons.scale),
                    ],
                  ),
                  Expanded(
                    child: SimpleBarChart.withRandomData(),
                  ),
                ]),
              ),
            )),
      ],
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const SimpleBarChart(this.seriesList, {super.key, this.animate = false});

  factory SimpleBarChart.withRandomData() {
    return SimpleBarChart(_createRandomData());
  }

  /// Returns random data for demonstration.
  static List<charts.Series<SensorEntry, String>> _createRandomData() {
    final random = Random();

    final data = [
      SensorEntry('Man', random.nextInt(10000)),
      SensorEntry('Tir', random.nextInt(10000)),
      SensorEntry('Ons', random.nextInt(10000)),
      SensorEntry('Tor', random.nextInt(10000)),
      SensorEntry('Fre', random.nextInt(10000)),
      SensorEntry('Lør', random.nextInt(10000)),
      SensorEntry('Søn', random.nextInt(10000)),
    ];

    return [
      charts.Series<SensorEntry, String>(
        id: 'Data',
        domainFn: (SensorEntry sales, _) => sales.day,
        measureFn: (SensorEntry sales, _) => sales.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

/// Demonstration data class.
class SensorEntry {
  final String day;
  final int value;

  SensorEntry(this.day, this.value);
}
