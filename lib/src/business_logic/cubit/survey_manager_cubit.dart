import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:research_package/research_package.dart';

part 'survey_manager_state.dart';

class SurveyManagerCubit extends Cubit<SurveyManagerState> {
  final SurveyEntryRepository _entryRepository;

  SurveyManagerCubit(this._entryRepository) : super(SurveyManagerInitial());

  // save entry
  Future<void> saveEntry(RPTaskResult result, String surveyId) async {
    await _entryRepository.save(result, surveyId);
    emit(SurveyManagerInitial());
  }

}
