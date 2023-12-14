part of 'weights_cubit.dart';

final class WeightsState extends Equatable {
  /// A list of [Weight] objects that contains lastest weight entries.
  final List<Weight> weightList;

  /// Returns the weight for today which is the first element in [WeightList]. Returns 0 if [WeightList] is empty.
  double get currentWeight => weightList.isEmpty ? 0 : weightList.first.weight;

  const WeightsState({
    this.weightList = const [],
  });

  @override
  List<Object> get props => [weightList];

  /// Returns a copy of [WeightState] with the given fields replaced with the new values.
  WeightsState copyWith({
    List<Weight>? weightList,
  }) {
    return WeightsState(
      weightList: weightList ?? this.weightList,
    );
  }
}
