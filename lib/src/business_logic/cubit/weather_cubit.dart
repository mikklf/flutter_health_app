import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  late StreamSubscription<LocationDto> locationSubscription;

  WeatherCubit() : super(const WeatherState()) {
    locationSubscription = LocationManager()
        .locationStream
        .listen((LocationDto loc) => onLocationUpdates(loc));
  }

  @override
  Future<void> close() async {
    locationSubscription.cancel();
    super.close();
  }

  void onLocationUpdates(LocationDto loc) async {
    // Check if last update was more than a hour ago

    // Fetch current weather
    // Insert information like temp, rain, wind, etc. into database
  }

}
