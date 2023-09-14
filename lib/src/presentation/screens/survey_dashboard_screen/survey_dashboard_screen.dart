import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/business_logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_screen/survey_screen.dart';

class SurveyDashboardScreen extends StatelessWidget {
  const SurveyDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SurveysBloc(
        services.get<ISurveyRepository>(),
      ),
      child: BlocConsumer<TabManagerCubit, TabManagerState>(
        listenWhen: (previous, current) => current.selectedTab == 1,
        listener: (context, state) => context.read<SurveysBloc>().add(LoadSurveys()),
        buildWhen: (previous, current) => current.selectedTab == 1,
        builder: (context, state) {
          return BlocBuilder<SurveysBloc, SurveysState>(
              builder: (context, state) {
              
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
              
            return RefreshIndicator(
              onRefresh: () {
                print("Refresh triggered");
                context.read<SurveysBloc>().add(LoadSurveys());
                return Future.delayed(const Duration(seconds: 1));
              },
              child: state.surveys.isNotEmpty
                  ? _buildSurveyListView(state)
                  : _buildNoSurveys(state),
            );
          });
        },
      ),
    );
  }

  Center _buildNoSurveys(SurveysState state) {
    return const Center(
        child: Text(
      'No surveys available',
      style: TextStyle(fontSize: 20),
    ));
  }

  ListView _buildSurveyListView(SurveysState state) {
    return ListView(
        children: state.surveys
            .map((survey) => SurveyCard(
                  survey: survey,
                ))
            .toList());
  }
}

class SurveyCard extends StatelessWidget {
  final Survey survey;

  const SurveyCard({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.blueGrey,
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (_) => SurveyScreen(survey: survey)))
              .then((_) =>
                  // Refresh survey list upon return to dashboard
                  BlocProvider.of<SurveysBloc>(context).add(LoadSurveys()));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading:
                  const Icon(Icons.list_alt, color: Colors.white, size: 45),
              title: Text(
                survey.title,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              subtitle: Text(survey.description,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
