import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/logic/cubit/tab_manager_cubit.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/presentation/survey_screen/survey_screen.dart';

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
              
            if (state.isLoading && state.activeSurveys.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
              
            return RefreshIndicator(
              onRefresh: () {
                context.read<SurveysBloc>().add(LoadSurveys());
                return Future.delayed(const Duration(seconds: 1));
              },
              child: state.activeSurveys.isEmpty
                  ? _buildNoSurveys(state)
                  : _buildSurveyListView(state),
            );
          });
        },
      ),
    );
  }

  ListView _buildNoSurveys(SurveysState state) {
    return ListView.builder(
              physics:const AlwaysScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: (context, index) {
                return const Column(
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Text(
                        "No surveys available",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                );
              },
            );
  }

  ListView _buildSurveyListView(SurveysState state) {
    var builder = ListView.builder(
      itemCount: state.activeSurveys.length,
      itemBuilder: (context, index) {
        return SurveyCard(survey: state.activeSurveys[index]);
      },
    );
    return builder;
  }
}

class SurveyCard extends StatelessWidget {
  final RPSurvey survey;

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
