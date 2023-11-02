import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:research_package/research_package.dart';

import 'setup_task_widget.dart';

class HomeAddressTaskWidget extends StatelessWidget {
  const HomeAddressTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      buildWhen: (previous, current) =>
          previous.homeAddress != current.homeAddress,
      builder: (context, state) {
        return SetupTaskWidget(
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
        );
      },
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
}
