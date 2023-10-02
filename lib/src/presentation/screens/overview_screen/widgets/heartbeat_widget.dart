import 'dart:math';

import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/data_card_box_widget.dart';

class HeartbeatWidget extends StatelessWidget {
  const HeartbeatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataCardBoxWidget(
        child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Heatbeat", style: Theme.of(context).textTheme.titleLarge),
          Text("87 bpm", style: Theme.of(context).textTheme.bodyLarge),
          const Icon(Icons.heart_broken),
        ],
      ),
      Expanded(
        child: SimpleBarChart.withRandomData(),
      ),
    ]));
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
