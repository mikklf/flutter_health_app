import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/domain/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/main.dart';
import 'package:flutter_health_app/src/business_logic/cubit/survey_manager_cubit.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:research_package/research_package.dart';

class SurveyScreen extends StatelessWidget {
  final Survey survey;

  const SurveyScreen({
    super.key,
    required this.survey,
  });

  void resultCallback(RPTaskResult result, BuildContext context) {
    context.read<SurveyManagerCubit>().saveEntry(result, survey.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SurveyManagerCubit(services.get<ISurveyEntryRepository>()),
      child: BlocBuilder<SurveyManagerCubit, SurveyManagerState>(
        builder: (context, state) {
          return _buildSurveyPage(context);
        },
      ),
    );
  }

  RPUITask _buildSurveyPage(BuildContext context) {
    return RPUITask(
      task: survey.task,
      onSubmit: (RPTaskResult result) async {
        resultCallback(result, context);
      },
      onCancel: (RPTaskResult? result) {
        print("Survey cancelled");
      },
    );
  }
}
