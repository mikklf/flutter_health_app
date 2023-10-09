import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  late StreamSubscription<LocationDto> locationSubscription;

  LocationCubit() : super(const LocationState());

  void startTracking() {
    debugPrint('Starting location tracking');

    // Setting interval only works on Android and is ignored on iOS, where location updates are determined by the OS.
    LocationManager().interval = 60 * 15; // 15 minutes
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Flutter Health App';
    LocationManager().notificationMsg = 'Flutter Health App is tracking your location';
    LocationManager().accuracy = LocationAccuracy.BALANCED;

    locationSubscription = LocationManager()
        .locationStream
        .listen((LocationDto loc) => _onLocationUpdates(loc));

    LocationManager().start();
  }

  void _onLocationUpdates(LocationDto loc) {
    debugPrint('Location update: ${loc.longitude}, ${loc.latitude}}');
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
