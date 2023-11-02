part of 'location_cubit.dart';

final class LocationState extends Equatable {
  final double homeStayPercent;
  
  const LocationState(this.homeStayPercent);
  
  @override
  List<Object> get props => [homeStayPercent];

  LocationState copyWith({
    double? homeStayPercent,
  }) {
    return LocationState(
      homeStayPercent ?? this.homeStayPercent,
    );
  }
}
