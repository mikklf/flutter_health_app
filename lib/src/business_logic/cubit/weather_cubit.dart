import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:weather/weather.dart' as open_weather;

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  late StreamSubscription<LocationDto> locationSubscription;

  final IWeatherRepository _weatherRepository;
  final int _minimumIntervalBetweenInsertsInMinutes = 60;

  WeatherCubit(this._weatherRepository)
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

  Future<open_weather.Weather> _fetchWeather(double lat, double long) async {
    var weather =
        open_weather.WeatherFactory("d4997e6222de1dec26fe9dc1109f5953");
    var currentWeather = await weather.currentWeatherByLocation(lat, long);
    return currentWeather;
  }

  Future<void> _saveWeatherFor(double latitude, double longitude) async {
    // Fetch current weather from weather package
    var data = await _fetchWeather(latitude, longitude);

    // Convert to our own Weather model
    var weather = Weather(
      temperature: data.temperature?.celsius,
      temperatureFeelsLike: data.tempFeelsLike?.celsius,
      humidity: data.humidity,
      cloudinessPercent: data.cloudiness,
      weatherCondition: data.weatherMain,
      weatherdescription: data.weatherDescription,
      latitude: data.latitude,
      longitude: data.longitude,
      timestamp: DateTime.now(),
      sunrise: data.sunrise,
      sunset: data.sunset,
    );

    _weatherRepository.insert(weather);

    emit(state.copyWith(
      weatherData: weather,
      timestamp: weather.timestamp,
    ));
  }
}
