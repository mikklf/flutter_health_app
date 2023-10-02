import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';

part 'surveys_event.dart';
part 'surveys_state.dart';

class SurveysBloc extends Bloc<SurveysEvent, SurveysState> {
  final ISurveyRepository _surveyRepository;

  SurveysBloc(this._surveyRepository) : super(const SurveysState()) {
    // Register event handlers
    on<SurveysEvent>((event, emit) {});
    on<LoadSurveys>(_onLoadSurvey);
  }

  /// Calls the [ISurveyRepository] to get the active surveys.
  Future<void> _onLoadSurvey(
      LoadSurveys event, Emitter<SurveysState> emit) async {

    emit(state.copyWith(isLoading: true));

    final surveys = await _surveyRepository.getActive();

    emit(state.copyWith(isLoading: false, surveys: surveys));
  }
}
