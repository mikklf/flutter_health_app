import 'dart:math';

import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_health_app/src/data/models/steps.dart';

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
              _buildHeader(context, 6400),
              _buildChart(context),
            ]),
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, int steps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Steps", style: Theme.of(context).textTheme.titleLarge),
        Text("$steps steps today",
            style: Theme.of(context).textTheme.bodyLarge),
        const Icon(Icons.directions_walk),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    final random = Random();

    final data = [
      Steps(steps: 10000, date: DateTime.now().subtract(Duration(days: 6))),
      Steps(steps: 7000, date: DateTime.now().subtract(Duration(days: 5))),
      Steps(steps: 8000, date: DateTime.now().subtract(Duration(days: 4))),
      Steps(steps: 2030, date: DateTime.now().subtract(Duration(days: 3))),
      Steps(steps: 12000, date: DateTime.now().subtract(Duration(days: 2))),
      Steps(steps: 552, date: DateTime.now().subtract(Duration(days: 1))),
      Steps(steps: 1440, date: DateTime.now()),
    ];

    List<String> weekNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    var chartData = [
      charts.Series<Steps, String>(
        id: 'Data',
        domainFn: (Steps x, _) => weekNames[x.date.weekday - 1],
        measureFn: (Steps x, _) => x.steps,
        data: data,
      )
    ];

    return Expanded(
      child: charts.BarChart(
        chartData,
        animate: false,
      ),
    );
  }
}