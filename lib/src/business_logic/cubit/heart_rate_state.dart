part of 'heart_rate_cubit.dart';

final class HeartRateState extends Equatable {
  final List<HeartRate> heartRateList;

  int get highestHeartRate => heartRateList.isEmpty ? 0 : heartRateList.map((e) => e.beatsPerMinute).reduce(max);
  int get lowestHeartRate => heartRateList.isEmpty ? 0 : heartRateList.map((e) => e.beatsPerMinute).reduce(min);


  const HeartRateState({
    this.heartRateList = const [],
  });

  @override
  List<Object> get props => [
    heartRateList,
  ];

  HeartRateState copyWith({
    List<HeartRate>? heartRateList,
  }) {
    return HeartRateState(
      heartRateList: heartRateList ?? this.heartRateList,
    );
  }
}