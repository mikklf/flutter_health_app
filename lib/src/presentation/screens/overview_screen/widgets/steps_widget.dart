import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/steps_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';

class StepsWidget extends StatelessWidget {
  const StepsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StepsCubit(
        services.get<IStepRepository>(),
      ),
      child: BlocListener<SyncCubit, SyncState>(
        listener: (context, state) {
          if (state.isSyncing == false) {
            context.read<StepsCubit>().getLastestSteps(7);
          }
        },
        child: BlocBuilder<StepsCubit, StepsCubitState>(
          builder: (context, state) {
            return SizedBox(
                height: 250,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      _buildHeader(context, state),
                      _buildChart(context, state),
                    ]),
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StepsCubitState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Steps", style: Theme.of(context).textTheme.titleLarge),
        Text("${state.stepsToday} steps today",
            style: Theme.of(context).textTheme.bodyLarge),
        const Icon(Icons.directions_walk),
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
