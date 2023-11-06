import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/location_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationRepository _locationRepository;
  late StreamSubscription<LocationDto> locationSubscription;

  final int _homeStayRangeThresholdInMeters = 250;
  final int _minimumIntervalBetweenInsertsInMinutes = 10;

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

  /// Called when a new location is received from the background location plugin.
  /// Inserts the location into the database and recalculates the home stay percentage.
  void onLocationUpdates(LocationDto loc) async {

    var latestLocation = await _locationRepository.getLastest();

    if (latestLocation != null) {
      var date = clock.now();
      var timeSinceLastInsert = date.difference(latestLocation.timestamp).inMinutes;

      if (timeSinceLastInsert < _minimumIntervalBetweenInsertsInMinutes) {
        return;
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var homeLatitude = prefs.getDouble("home_latitude");
    var homeLongitude = prefs.getDouble("home_longitude");

    if (homeLatitude == null || homeLongitude == null) {
      return;
    }

    var distance = _calculateDistance(
      loc.latitude,
      loc.longitude,
      homeLatitude,
      homeLongitude,
    );

    var location = Location(
      longitude: loc.longitude,
      latitude: loc.latitude,
      isHome: distance < _homeStayRangeThresholdInMeters,
      timestamp: clock.now(),
    );

    await _locationRepository.insert(location);

    emit(state.copyWith(
        homeStayPercent: await _calculateHomeStayPercentage(),
      ));
  }

  Future<double> _calculateHomeStayPercentage() async {
    var date = clock.now();

    var locations = await _locationRepository.getLocationsForDay(date);

    if (locations.isEmpty) {
      return -1;
    }

    var homeStayDuration = 0;
    var lastDataPointTime =
        DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);

    for (var location in locations) {
      if (location.isHome) {
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

  double _calculateDistance(double fromLatitude, double fromLongitude, double toLatitude, double toLongitude) {
  // Earth radius in meters
  const radius = 6371e3;

  // Convert degrees to radians for latitude of both locations
  var lat1 = fromLatitude * pi / 180;
  var lat2 = toLatitude * pi / 180;

  // Calculate the difference in latitude and longitude between the two locations in radians
  var deltaLat = (toLatitude - fromLatitude) * pi / 180;
  var deltaLon = (toLongitude - fromLongitude) * pi / 180;

  // Haversine formula: 
  // a is the square of half the chord length between the points
  // c is the angular distance in radians
  var a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
  
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Calculate the distance in meters
  var distance = radius * c;

  return distance;
}
}
