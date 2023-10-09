part of 'location_cubit.dart';

final class LocationState extends Equatable {
  
  final List<Location> locations;

  final double homeStayPercent;
  
  const LocationState(this.locations, this.homeStayPercent);
  
  @override
  List<Object> get props => [locations, homeStayPercent];

  LocationState copyWith({
    List<Location>? locations,
    double? homeStayPercent,
  }) {
    return LocationState(
      locations ?? this.locations,
      homeStayPercent ?? this.homeStayPercent,
    );
  }
}
