import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_app/domain/interfaces/location_repository.dart';
import 'package:flutter_health_app/src/data/models/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationRepository _locationRepository;
  late StreamSubscription<LocationDto> locationSubscription;

  LocationCubit(this._locationRepository) : super(const LocationState([], 0));

  void loadLocations() async {
    var locations =
        await _locationRepository.getLocationsForDay(DateTime.now());
    emit(state.copyWith(
        locations: locations,
        homeStayPercent: await _calculateHomeStayPercentage()));
  }

  void startTracking() {
    debugPrint('Starting location tracking');

    // Setting interval only works on Android and is ignored on iOS, where location updates are determined by the OS.
    LocationManager().interval = 60 * 15; // 15 minutes
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Flutter Health App';
    LocationManager().notificationMsg =
        'Flutter Health App is tracking your location';
    LocationManager().accuracy = LocationAccuracy.BALANCED;

    locationSubscription = LocationManager()
        .locationStream
        .listen((LocationDto loc) => _onLocationUpdates(loc));

    LocationManager().start();
  }

  Future<void> _onLocationUpdates(LocationDto loc) async {
    debugPrint('Location update: ${loc.longitude}, ${loc.latitude}}');

    var location = Location(
      longitude: loc.longitude,
      latitude: loc.latitude,
      date: DateTime.now(),
    );

    var didInsert = await _locationRepository.insert(location);

    if (didInsert) {
      emit(state.copyWith(
          locations: [...state.locations, location],
          homeStayPercent: await _calculateHomeStayPercentage()));
    }
  }

  void stopTracking() {
    locationSubscription.cancel();
    LocationManager().stop();
  }

  Future<double> _calculateHomeStayPercentage() async {
    var date = DateTime.now();

    var homeLocation = Location(
      latitude: 55.931852785772655,
      longitude: 12.294658981887142,
      date: DateTime.now(),
    );

    var locations = await _locationRepository.getLocationsForDay(date);

    if (locations == null || locations.isEmpty) {
      return -1;
    }

    var homeStayDuration = 0;
    var lastDataPointTime =
        DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);

    for (var location in locations) {
      var distance = location.distanceTo(homeLocation);
      if (distance < 100) {
        homeStayDuration +=
            location.date.difference(lastDataPointTime).inSeconds;
      }

      lastDataPointTime = location.date;
    }

    var elapsedTime = lastDataPointTime
        .difference(DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0))
        .inSeconds;

    var percentage = (homeStayDuration / elapsedTime) * 100;

    return percentage;
  }
}