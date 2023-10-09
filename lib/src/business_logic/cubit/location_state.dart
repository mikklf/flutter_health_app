part of 'location_cubit.dart';

final class LocationState extends Equatable {
  
  final List<Location> locations;
  
  const LocationState(this.locations);
  
  @override
  List<Object> get props => [];

  LocationState copyWith({
    List<Location>? locations,
  }) {
    return LocationState(
      locations ?? this.locations,
    );
  }
}
