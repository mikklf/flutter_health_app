import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/survey.dart';
import '../../data/repositories/survey_repository.dart';

part 'surveys_event.dart';
part 'surveys_state.dart';

class SurveysBloc extends Bloc<SurveysEvent, SurveysState> {
  final ISurveyRepository _surveyRepository;

  SurveysBloc(this._surveyRepository) : super(const SurveysState()) {
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
