import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/surveys_cubit.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:research_package/research_package.dart';


class SurveyScreen extends StatelessWidget {
  final RPSurvey survey;

  const SurveyScreen({
    super.key,
    required this.survey,
  });

  void resultCallback(RPTaskResult result, BuildContext context) {
    context.read<SurveysCubit>().saveEntry(result, survey.id);
  }

  @override
  Widget build(BuildContext context) {
      return _buildSurveyPage(context);
  }

  RPUITask _buildSurveyPage(BuildContext context) {
    return RPUITask(
      task: survey.task,
      onSubmit: (RPTaskResult result) async {
        resultCallback(result, context);
      },
      onCancel: (RPTaskResult? result) {
        // Do cancellation logic here
      },
    );
  }
}