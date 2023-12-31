import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/logic/weights_cubit.dart';
import 'package:flutter_health_app/src/data/models/weight.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/data_card_box_widget.dart';
import 'package:research_package/research_package.dart';

class WeightWidget extends StatelessWidget {
  const WeightWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeightsCubit(
        services.get<IWeightRepository>(),
      )..getLatestWeights(),
      child: BlocBuilder<WeightsCubit, WeightsState>(
        builder: (context, state) {
          return DataCardBoxWidget(
              child: Column(children: [
            _buildHeader(context, state),
            _buildChart(context, state),
          ]));
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WeightsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.monitor_weight_outlined),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weight", style: Theme.of(context).textTheme.titleLarge),
                Text("Last 7 entries", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        ElevatedButton(
          // make smaller
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _buildWeightSurvey(context)),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.add_circle_outline, size: 18),
              SizedBox(width: 4),
              Text("Update", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Text("${state.currentWeight} kg",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  RPUITask _buildWeightSurvey(BuildContext context) {
    var task = RPOrderedTask(
      identifier: "weight",
      steps: [
        RPQuestionStep(
            identifier: "weight",
            title: "Update weight for today",
            answerFormat:
                RPDoubleAnswerFormat(minValue: 25, maxValue: 500, suffix: "kg"))
      ],
    );

    onSubmit(RPTaskResult result) async {
      // Fetch weight from survey package result
      var stepResult = result.results["weight"] as RPStepResult;
      var weight = double.parse(stepResult.results["answer"]);

      // Round weight to one decimal
      weight = double.parse(weight.toStringAsFixed(1));

      context.read<WeightsCubit>().updateWeight(DateTime.now(), weight);
    }

    return RPUITask(
      task: task,
      onSubmit: onSubmit,
    );
  }

  Widget _buildChart(BuildContext context, WeightsState state) {
    var chartData = [
      charts.Series<Weight, DateTime>(
        id: 'Data',
        domainFn: (Weight x, _) => x.date,
        measureFn: (Weight x, _) => x.weight,
        data: state.weightList,
      )
    ];

    return Expanded(
      child: charts.TimeSeriesChart(
        chartData,
        animate: false,
        primaryMeasureAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredTickCount: 7,
          ),
        ),
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
        behaviors: [
          charts.LinePointHighlighter(
            symbolRenderer: charts.CircleSymbolRenderer(),
            selectionModelType: charts.SelectionModelType.info,
          ),
          charts.RangeAnnotation(state.weightList
              .map((e) => charts.LineAnnotationSegment(
                    e.date,
                    charts.RangeAnnotationAxisType.domain,
                    color: charts.MaterialPalette.gray.shade100,
                  ))
              .toList()),
        ],
      ),
    );
  }
}
