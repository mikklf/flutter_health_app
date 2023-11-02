import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';

part 'surveys_state.dart';

class SurveysCubit extends Cubit<SurveysState> {
  final ISurveyRepository _surveyRepository;
  
  SurveysCubit(this._surveyRepository) : super(const SurveysState());

  Future<void> loadSurveys() async {
    emit(state.copyWith(isLoading: true));

    final surveys = await _surveyRepository.getActive();

    emit(state.copyWith(isLoading: false, surveys: surveys));
  }
}
