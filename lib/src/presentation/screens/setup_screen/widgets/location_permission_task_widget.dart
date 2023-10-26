import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

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
            _requestLocationPermissions(context);
          },
        );
      },
    );
  }

  void _requestLocationPermissions(BuildContext context) async {
    // NOTE: This is a basic implementation of the location permission request.
    // It works but does not provide a good user experience.

    var status = await Permission.location.status;

    await Permission.location.request();

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _sendSnackBar(context,
            "Location permissions are permanently denied. Please enable them in your phone settings.");
      }
      return;
    }

    // Check if we can request locationAlways permission
    var alwaysStatus = await Permission.locationAlways.status;
    if (alwaysStatus.isDenied) {
      await Permission.locationAlways.request();
    }

    alwaysStatus = await Permission.locationAlways.status;
    if (alwaysStatus.isDenied || alwaysStatus.isPermanentlyDenied) {
      if (context.mounted) {
        _sendSnackBar(context,
            "Always access to location is required to use the app effectively. Please enable it in your phone settings.");
      }
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
