import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/business_logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_screen/survey_screen.dart';

class SurveyDashboardScreen extends StatelessWidget {
  const SurveyDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveysBloc, SurveysState>(builder: (context, state) {
      return Column(
          children: state.surveys
              .map((survey) => SurveyCard(
                    survey: survey,
                  ))
              .toList());
    });
  }
}

class SurveyCard extends StatelessWidget {
  final Survey survey;

  const SurveyCard({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Card (
        margin: EdgeInsets.all(10),
        color: Colors.blueGrey,
        elevation: 10,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => SurveyScreen(survey: survey.task)));            
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon (
                    Icons.list_alt,
                    color: Colors.white,
                    size: 45
                ),
                title: Text(
                  survey.title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                subtitle: Text(survey.description, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
  }
}
