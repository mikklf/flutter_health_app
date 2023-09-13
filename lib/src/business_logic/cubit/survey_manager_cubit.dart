import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:research_package/research_package.dart';

part 'survey_manager_state.dart';

class SurveyManagerCubit extends Cubit<SurveyManagerState> {
  final ISurveyEntryRepository _entryRepository;

  SurveyManagerCubit(this._entryRepository) : super(const SurveyManagerState());

  /// Calls the [ISurveyEntryRepository] to save the [RPTaskResult] to the database.
  Future<void> saveEntry(RPTaskResult result, String surveyId) async {
    await _entryRepository.save(result, surveyId);
  }

}
