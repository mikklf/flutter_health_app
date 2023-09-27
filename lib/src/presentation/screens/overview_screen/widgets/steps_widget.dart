import 'dart:math';

import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;


class StepsWidget extends StatelessWidget {
  const StepsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        ));
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

class SensorEntry {
  final String day;
  final int value;

  SensorEntry(this.day, this.value);
}