import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/survery.dart';
import '../../data/repositories/survey_repository.dart';

part 'surveys_event.dart';
part 'surveys_state.dart';

class SurveysBloc extends Bloc<SurveysEvent, SurveysState> {
  final SurveyRepository _surveyRepository;

  SurveysBloc(this._surveyRepository) : super(const SurveysInitial(<Survey>[])) {
    on<SurveysEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadSurveys>(_onLoadSurvey);
  }

  Future<void> _onLoadSurvey(LoadSurveys event, Emitter<SurveysState> emit) async {
    
    final surveys = await _surveyRepository.getActiveSurveys();
    emit(SurveysInitial(surveys));

  }
}
