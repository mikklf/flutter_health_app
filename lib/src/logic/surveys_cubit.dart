import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:research_package/model.dart';

part 'surveys_state.dart';

class SurveysCubit extends Cubit<SurveysState> {
  final ISurveyRepository _surveyRepository;
  final ISurveyEntryRepository _surveyEntryRepository;
  
  SurveysCubit(this._surveyRepository, this._surveyEntryRepository) : super(const SurveysState());

  /// Loads all active surveys from the repository and updates the state.
  Future<void> loadSurveys() async {
    emit(state.copyWith(isLoading: true));

    final surveys = await _surveyRepository.getActive();

    emit(state.copyWith(isLoading: false, surveys: surveys));
  }

  /// Calls the [ISurveyEntryRepository] to save the [RPTaskResult] to the database.
  Future<void> saveEntry(RPTaskResult result, String surveyId) async {
    await _surveyEntryRepository.save(result, surveyId);
  }
}
