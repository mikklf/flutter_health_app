import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/logic/heart_rate_cubit.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/data_card_box_widget.dart';

class HeartRateWidget extends StatelessWidget {
  const HeartRateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeartRateCubit(
        services.get<IHeartRateRepository>(),
      ),
      child: BlocListener<SyncCubit, SyncState>(
        listener: (context, state) {
          if (state.isSyncing == false) {
            context.read<HeartRateCubit>().getHeartRatesForDay();
          }
        },
        child: BlocBuilder<HeartRateCubit, HeartRateState>(
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

  Widget _buildHeader(BuildContext context, HeartRateState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.monitor_heart_outlined),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Heart rate", style: Theme.of(context).textTheme.titleLarge),
                Text("Today", style: Theme.of(context).textTheme.bodySmall),
              ],
            )
          ],
        ),
        Text("${state.lowestHeartRate} - ${state.highestHeartRate} bpm",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildChart(BuildContext context, HeartRateState state) {
    var chartData = [
      charts.Series<HeartRate, DateTime>(
        id: 'Data',
        domainFn: (HeartRate x, _) => x.timestamp,
        measureFn: (HeartRate x, _) => x.beatsPerMinute,
        data: state.heartRateList,
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
      ),
    );
  }
}
