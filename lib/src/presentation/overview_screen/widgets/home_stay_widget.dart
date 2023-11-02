import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/location_cubit.dart';

class HomeStayWidget extends StatelessWidget {
  const HomeStayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<LocationCubit>().loadLocations();
    return BlocBuilder<LocationCubit, LocationState>(
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
                        Text("Percentage of time spent at home",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                Text(
                    state.homeStayPercent == -1
                        ? ".. %"
                        : "${state.homeStayPercent.toStringAsFixed(0)} %",
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        );
      },
    );
  }
}
