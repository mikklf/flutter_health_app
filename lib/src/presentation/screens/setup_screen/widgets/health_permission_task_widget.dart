import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';

import 'setup_task_widget.dart';

class HealthPermisionTaskWidget extends StatelessWidget {
  const HealthPermisionTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
            buildWhen: (previous, current) =>
                previous.isHealthPermissionGranted !=
                current.isHealthPermissionGranted,
            builder: (context, state) {
              return SetupTaskWidget(
                title: "Health data permissions",
                description:
                    "Give the app permissions to access your health data",
                icon: Icons.health_and_safety,
                canResubmit: true,
                buttonText: "Reauthorize",
                isFinished: state.isHealthPermissionGranted,
                onPressed: () {
                  context.read<SetupCubit>().requestHealthPermissions();
                },
              );
            },
          );
  }
}
