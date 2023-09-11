import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/survey_manager_cubit.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:research_package/research_package.dart';
import 'dart:convert';

import '../../../../main.dart';
import '../../../data/repositories/survey_entry_repository.dart';

class SurveyScreen extends StatelessWidget {
  final Survey survey;

  const SurveyScreen({
    super.key,
    required this.survey,
  });

  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void resultCallback(RPTaskResult result, BuildContext context) {
    // Do anything with the result
    // print(_encode(result));
    //printWrapped(_encode(result));
    context.read<SurveyManagerCubit>().saveEntry(result, survey.id);
  }

  void cancelCallBack(RPTaskResult result) {
    // Do anything with the result at the moment of the cancellation
    print("The result so far:\n" + _encode(result));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SurveyManagerCubit(services.get<ISurveyEntryRepository>()),
      child: BlocBuilder<SurveyManagerCubit, SurveyManagerState>(
        builder: (context, state) {
          return _buildRPUITask(context);
        },
      ),
    );
  }

  RPUITask _buildRPUITask(BuildContext context) {
    return RPUITask(
      task: survey.task,
      onSubmit: (RPTaskResult result) async {
        resultCallback(result, context);
      },
      onCancel: (RPTaskResult? result) {
        if (result == null) {
          print("No result");
        } else {
          cancelCallBack(result);
        }
      },
    );
  }
}
