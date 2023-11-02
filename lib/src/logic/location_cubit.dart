import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationRepository _locationRepository;
  late StreamSubscription<LocationDto> locationSubscription;

  LocationCubit(this._locationRepository) : super(const LocationState(0)) {
    locationSubscription = LocationManager()
        .locationStream
        .listen((LocationDto loc) => onLocationUpdates(loc));
  }

  /// Loads locations from the database, calculates and emits the home stay percentage.
  void loadLocations() async {
    emit(state.copyWith(homeStayPercent: await _calculateHomeStayPercentage()));
  }

  @override
  Future<void> close() async {
    locationSubscription.cancel();
    super.close();
  }

  void onLocationUpdates(LocationDto loc) async {
    var location = Location(
      longitude: loc.longitude,
      latitude: loc.latitude,
      timestamp: DateTime.now(),
    );

    var didInsert = await _locationRepository.insert(location);

    if (didInsert) {
      emit(state.copyWith(
        homeStayPercent: await _calculateHomeStayPercentage(),
      ));
    }
  }

  Future<double> _calculateHomeStayPercentage() async {
    var date = DateTime.now();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var homeLatitude = prefs.getDouble("home_latitude");
    var homeLongitude = prefs.getDouble("home_longitude");
        
    if (homeLatitude == null || homeLongitude == null) {
      return -1;
    }

    var homeLocation = Location(
      latitude: homeLatitude,
      longitude: homeLongitude,
      timestamp: DateTime.now(),
    );

    var locations = await _locationRepository.getLocationsForDay(date);

    if (locations.isEmpty) {
      return -1;
    }

    var homeStayDuration = 0;
    var lastDataPointTime =
        DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);

    for (var location in locations) {
      var distance = location.distanceTo(homeLocation);
      if (distance < 100) {
        homeStayDuration +=
            location.timestamp.difference(lastDataPointTime).inSeconds;
      }

      lastDataPointTime = location.timestamp;
    }

    var elapsedTime = lastDataPointTime
        .difference(DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0))
        .inSeconds;

    var percentage = (homeStayDuration / elapsedTime) * 100;

    return percentage;
  }
}
