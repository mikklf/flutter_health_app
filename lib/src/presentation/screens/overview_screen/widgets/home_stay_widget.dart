import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/location_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/steps_cubit.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';

class HomeStayWidget extends StatelessWidget {
  const HomeStayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(
        services.get<ILocationRepository>(),
      )..loadLocations(),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Home stay",
                              style: Theme.of(context).textTheme.titleLarge),
                          const Text("Percentage of time spent at home")
                        ],
                      ),
                    ],
                  ),
                  Text("${state.homeStayPercent.toStringAsFixed(0)} %",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StepsCubitState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.directions_walk),
            const SizedBox(width: 8),
            Text("Steps", style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        Text("${state.stepsToday} steps today",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildChart(BuildContext context, StepsCubitState state) {
    var chartData = [
      charts.Series<Steps, String>(
        id: 'Data',
        domainFn: (Steps x, _) => "${x.date.day}/${x.date.month}",
        measureFn: (Steps x, _) => x.steps,
        data: state.stepsList,
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
