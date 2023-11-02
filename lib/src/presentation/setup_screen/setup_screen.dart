import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/constants.dart';
import 'package:flutter_health_app/src/logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/consent_task_widget.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/health_permission_task_widget.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/home_address_task_widget.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/informed_consent_objects.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/location_permission_task_widget.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        children: [
          // Header
          Text("${Constants.appName} Setup",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text(
              "Complete the following tasks to setup and start using the application.",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 5),
          const Divider(
            thickness: 2,
          ),
          const SizedBox(height: 5),

          // Setup tasks
          ConsentTaskWidget(consentTask: consentTask),
          const SizedBox(height: 15),

          const HomeAddressTaskWidget(),
          const SizedBox(height: 15),

          const LocationPermisionTaskWidget(),
          const SizedBox(height: 15),

          const HealthPermisionTaskWidget(),
          const SizedBox(height: 15),

          BlocBuilder<SetupCubit, SetupState>(
            builder: (context, state) => _finishButton(context, state),
          ),

          BlocBuilder<SetupCubit, SetupState>(
            buildWhen: (previous, current) => previous.snackbarMessage != current.snackbarMessage,
            builder: (context, state) {
              if (state.snackbarMessage != "") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.snackbarMessage),
                    ),
                  );
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    ));
  }

  Widget _finishButton(BuildContext context, SetupState state) {
    return ElevatedButton(
      onPressed: state.canFinishSetup
          ? () {
              context.read<SetupCubit>().completeSetup();
            }
          : null,
      child: const Text("Finish setup"),
    );
  }
}
