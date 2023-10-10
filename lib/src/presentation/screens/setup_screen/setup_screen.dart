import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/main.dart';
import 'package:flutter_health_app/src/business_logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/screens/setup_screen/informed_consent_objects.dart';
import 'package:research_package/research_package.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});
  // Informed consent
  // Get relevant user data (Home location)
  // permissions (https://pub.dev/packages/permission_handler)

  RPUITask _buildConsentScreen(BuildContext context) {
    onSubmit(RPTaskResult result) async {
      debugPrint("Consent result: $result");
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
    return BlocProvider(
      create: (context) => SetupCubit(),
      child: BlocBuilder<SetupCubit, SetupState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Setup screen',
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => _buildConsentScreen(context)),
                          );
                        },
                        child: const Text("Give consent")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    _buildHomeAddressSurvey(context)),
                          );
                        },
                        child: const Text("Set home address")),
                    Text(state.homeAddress),
                    const SizedBox(height: 30),
                    ElevatedButton(onPressed: () {
                      Navigator.of(context).popUntil((route) => false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const MainApp(skipSetup: true,)));
                    }, child: const Text("Finish")),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
