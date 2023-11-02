import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:research_package/research_package.dart';

import 'setup_task_widget.dart';

class ConsentTaskWidget extends StatelessWidget {
  final RPOrderedTask consentTask;

  const ConsentTaskWidget({
    super.key,
    required this.consentTask,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      buildWhen: (previous, current) =>
          previous.isConsentGiven != current.isConsentGiven,
      builder: (context, state) {
        return SetupTaskWidget(
          title: "Informed Consent",
          description: "Read and accept the informed consent",
          icon: Icons.edit_document,
          isFinished: state.isConsentGiven,
          canResubmit: false,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _buildConsentScreen(context)),
            );
          },
        );
      },
    );
  }

  RPUITask _buildConsentScreen(BuildContext context) {
    onSubmit(RPTaskResult result) async {
      context.read<SetupCubit>().saveConsent(result);
    }

    return RPUITask(
      task: consentTask,
      onSubmit: onSubmit,
    );
  }
}
