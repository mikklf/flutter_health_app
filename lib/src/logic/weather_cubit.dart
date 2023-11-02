import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  late StreamSubscription<LocationDto> locationSubscription;

  final IWeatherRepository _weatherRepository;
  final IWeatherProvider _weatherProvider;
  final int _minimumIntervalBetweenInsertsInMinutes = 60;

  WeatherCubit(this._weatherRepository, this._weatherProvider)
      : super(WeatherState(timestamp: DateTime(0))) {
    locationSubscription = LocationManager()
        .locationStream
        .listen((LocationDto loc) => onLocationUpdates(loc));
  }

  Future<void> loadCurrentWeather() async {
    var lastest = await _weatherRepository.getLastest();

    if (lastest == null) {
      return;
    }

    emit(state.copyWith(
      weatherData: lastest,
      timestamp: lastest.timestamp,
    ));
  }

  @override
  Future<void> close() async {
    locationSubscription.cancel();
    super.close();
  }

  void onLocationUpdates(LocationDto loc) async {
    var lastest = await _weatherRepository.getLastest();

    if (lastest == null) {
      await _saveWeatherFor(loc.latitude, loc.longitude);
      return;
    }

    var diff = DateTime.now().difference(lastest.timestamp).inMinutes;

    if (diff > _minimumIntervalBetweenInsertsInMinutes) {
      await _saveWeatherFor(loc.latitude, loc.longitude);
    }
  }

  Future<void> _saveWeatherFor(double latitude, double longitude) async {
    var weather = await _weatherProvider.fetchWeather(latitude, longitude);

    _weatherRepository.insert(weather);

    emit(state.copyWith(
      weatherData: weather,
      timestamp: weather.timestamp,
    ));
  }
}
