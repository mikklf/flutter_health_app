import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';

import 'setup_task_widget.dart';

class LocationPermisionTaskWidget extends StatelessWidget {
  const LocationPermisionTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      buildWhen: (previous, current) =>
          previous.isLocationPermissionGranted !=
          current.isLocationPermissionGranted,
      builder: (context, state) {
        return SetupTaskWidget(
          title: "Location permissions",
          description: "Give the app permissions to access your location",
          icon: Icons.location_on,
          isFinished: state.isLocationPermissionGranted,
          onPressed: () {
            context.read<SetupCubit>().requestLocationPermissions();
          },
        );
      },
    );
  }
}
