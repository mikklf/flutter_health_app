import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/informed_consent_objects.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:research_package/research_package.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});
  // Informed consent
  // Get relevant user data (Home location)
  // permissions (https://pub.dev/packages/permission_handler)

  RPUITask _buildConsentScreen(BuildContext context) {
    onSubmit(RPTaskResult result) async {
      context.read<SetupCubit>().saveConsent(result);
    }

    return RPUITask(
      task: consentTask,
      onSubmit: onSubmit,
    );
  }

  RPUITask _buildHomeAddressSurvey(BuildContext context) {
    var task = RPOrderedTask(
      identifier: "homeAddressSurvey",
      steps: [
        RPQuestionStep(
            identifier: "homeAddress",
            title: "What is your home address?",
            answerFormat: RPTextAnswerFormat(
                hintText: "Enter your address", autoFocus: true))
      ],
    );

    onSubmit(RPTaskResult result) async {
      var surveyResult = result.results["homeAddress"] as RPStepResult;
      var address = surveyResult.results["answer"];

      if (context.mounted) {
        context.read<SetupCubit>().updateHomeAddress(address);
      }
    }

    return RPUITask(
      task: task,
      onSubmit: onSubmit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            children: [
              SetupTaskWidget(
                title: "Informed Consent",
                description: "Read and accept the informed consent",
                icon: Icons.edit_document,
                isFinished: state.isConsentGiven,
                canResubmit: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => _buildConsentScreen(context)),
                  );
                },
              ),
              const SizedBox(height: 15),
              SetupTaskWidget(
                title: "Home address",
                description: "Set your home address",
                icon: Icons.home,
                isFinished: state.homeAddress.isNotEmpty &&
                    state.homeAddress != "No location found",
                canResubmit: true,
                completionText: state.homeAddress,
                buttonText: "Update",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => _buildHomeAddressSurvey(context)),
                  );
                },
              ),
              const SizedBox(height: 15),
              SetupTaskWidget(
                title: "Location permissions",
                description: "Give the app permissions to access your location",
                icon: Icons.location_on,
                isFinished: false,
                onPressed: () {
                  _requestLocationPermissions(context);
                },
              ),
              const SizedBox(height: 15),
              SetupTaskWidget(
                title: "Health data permissions",
                description:
                    "Give the app permissions to access your health data",
                icon: Icons.health_and_safety,
                isFinished: false,
                onPressed: () {
                  _requestHealthPermissions(context);
                },
              ),
              const SizedBox(height: 15),
              _finishButton(context),
            ],
          ),
        ));
      },
    );
  }

  void _requestLocationPermissions(BuildContext context) async {
    // NOTE: This is a basic implementation of the location permission request.
    // It works but does not provide a good user experience.

    // Check if we have location permissions
    var status = await Permission.location.status;

    await Permission.location.request();

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _sendSnackBar(context, "Location permissions are permanently denied. Please enable them in your phone settings.");
      }
      return;
    }

    // Check if we can request locationAlways permission
    var alwaysStatus = await Permission.locationAlways.status;
    if (alwaysStatus.isDenied) {
      await Permission.locationAlways.request();
    }

    if (alwaysStatus.isDenied || alwaysStatus.isPermanentlyDenied) {
      if (context.mounted) {
        _sendSnackBar(context, "Always access to location is required to use the app effectively. Please enable it in your phone settings.");
      }
    }
  }


  void _requestHealthPermissions(BuildContext context) async {
    var success = await services.get<IHealthProvider>().requestAuthorization();

    if (!success) {
      if (context.mounted) {
        _sendSnackBar(context, "Could not get health permissions. Access to health data is required to use the app effectively.");
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

  Widget _finishButton(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ElevatedButton(
              onPressed: snapshot.data == true
                  ? () {
                      context.read<SetupCubit>().completeSetup();
                    }
                  : null,
              child: const Text("Finish setup"),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
        future: context.read<SetupCubit>().canFinshSetup());
  }
}

class SetupTaskWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? completionText;
  final String buttonText;
  final IconData icon;
  final void Function() onPressed;
  final bool isFinished;
  final bool canResubmit;

  const SetupTaskWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
    required this.isFinished,
    this.completionText,
    this.canResubmit = false,
    this.buttonText = "Start",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: isFinished
                ? const Icon(Icons.check_circle, color: Colors.green)
                : Icon(icon),
            title: Text(title),
            subtitle: Text(description),
          ),
          const Divider(indent: 16, endIndent: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!isFinished || (isFinished && canResubmit))
                _startButton()
              else
                _finishText(),
              if (completionText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(completionText!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _startButton() {
    return TextButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }

  Widget _finishText() {
    return const TextButton(
      onPressed: null,
      child: Text('Done'),
    );
  }
}
