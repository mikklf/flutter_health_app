import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
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
                  _requestHealthPermissions(context);
                },
              );
            },
          );
  }

  void _requestHealthPermissions(BuildContext context) async {
    // NOTE: This is a minimal implementation of the health permission request.
    // It works but does not provide a good user experience.

    var success = await services.get<IHealthProvider>().requestAuthorization();

    if (!success) {
      if (context.mounted) {
        context.read<SetupCubit>().saveHealthPermission(success: false);
        _sendSnackBar(context,
            "Could not get health permissions. Access to health data is required to use the app effectively.");
      }
    }

    if (context.mounted) {
      context.read<SetupCubit>().saveHealthPermission(success: true);
      _sendSnackBar(context, "Health permissions granted.");
    }
  }

  void _sendSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
