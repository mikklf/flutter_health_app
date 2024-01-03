import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/sync_cubit.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/home_stay_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/weather_widget.dart';

import 'widgets/steps_widget.dart';
import 'widgets/weight_widget.dart';

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
        children: const [
          // Register widgets here
          StepsWidget(),
          WeightWidget(),
          HomeStayWidget(),
          HeartRateWidget(),
          WeatherWidget(),
        ],
      ),
    );
  }
}
