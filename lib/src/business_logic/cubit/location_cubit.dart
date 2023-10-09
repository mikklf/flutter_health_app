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

  LocationCubit(this._locationRepository) : super(const LocationState([]));

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
      emit(state.copyWith(locations: [...state.locations, location]));
    }
  }

  void stopTracking() {
    locationSubscription.cancel();
    LocationManager().stop();
  }
}

// Home location - long, lat

// tracking user locaiton - 

// function calculateHomeStayPercentage():
//     homeLocation = getHomeLocation()
//     locationDataPoints = getAllLocationDataPointsSinceMidnight()
    
//     homeStayDuration = 0
//     lastDataPointTime = midnight

//     for dataPoint in locationDataPoints:
//         if isWithinThreshold(homeLocation, dataPoint.location):
//             homeStayDuration += dataPoint.timestamp - lastDataPointTime

//         lastDataPointTime = dataPoint.timestamp

//     elapsedTime = getCurrentTime() - lastKnownStopTime
//     percentage = (homeStayDuration / elapsedTime) * 100

//     return percentage
