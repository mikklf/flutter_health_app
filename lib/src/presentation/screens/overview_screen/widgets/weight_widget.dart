import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/steps_cubit.dart';
import 'package:flutter_health_app/src/business_logic/cubit/sync_cubit.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/data_card_box_widget.dart';
import 'package:research_package/research_package.dart';

class WeightWidget extends StatelessWidget {
  const WeightWidget({
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
            return DataCardBoxWidget(
                child: Column(children: [
              _buildHeader(context, state),
              _buildChart(context, state),
            ]));
          },
        ),
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
            Text("Weight", style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            var task = RPOrderedTask(
              identifier: "weight",
              steps: [
                RPQuestionStep(
                    identifier: "weight",
                    title: "Update weight for today",
                    answerFormat: RPDoubleAnswerFormat(
                        minValue: 25, maxValue: 500, suffix: "kg"))
              ],
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RPUITask(
                  task: task,
                  onSubmit: (RPTaskResult result) async {
                    String _encode(Object object) =>
                        const JsonEncoder.withIndent(' ').convert(object);
                    void printWrapped(String text) {
                      final pattern =
                          RegExp('.{1,800}'); // 800 is the size of each chunk
                      pattern
                          .allMatches(text)
                          .forEach((match) => print(match.group(0)));
                    }

                    printWrapped(_encode(result));
                  },
                  onCancel: (RPTaskResult? result) {
                    // Do cancellation logic here
                  },
                ),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.add_circle_outline),
              SizedBox(width: 8),
              Text("Update"),
            ],
          ),
        ),
        Text("${state.stepsToday} kg",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildChart(BuildContext context, StepsCubitState state) {
    var chartData = [
      charts.Series<Steps, DateTime>(
        id: 'Data',
        domainFn: (Steps x, _) => x.date,
        measureFn: (Steps x, _) => x.steps,
        data: state.stepsList,
      )
    ];

    return Expanded(
      child: charts.TimeSeriesChart(
        chartData,
        animate: false,
      ),
    );
  }
}
