import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/models/weight.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weight_repository.dart';

part 'weights_state.dart';

class WeightsCubit extends Cubit<WeightsCubitState> {
  final IWeightRepository _weightRepository;

  /// The number of entries to return when calling [getLatestWeights]
  final int _numOfEntries = 7;

  WeightsCubit(this._weightRepository) : super(const WeightsCubitState());

  /// Returns the latest weight entry. Returns empty list if no data is found.
  Future<void> getLatestWeights() async {
    var weightsData = await _weightRepository.getLatestWeights(_numOfEntries);

    emit(state.copyWith(weightList: weightsData));
  }

  /// Adds a new weight entry and calls [getLatestWeights] to update the state.
  Future<void> updateWeight(DateTime date, double weight) async {
    await _weightRepository.updateWeight(date, weight);
    await getLatestWeights();
  }
}
