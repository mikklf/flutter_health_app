import 'package:flutter_health_app/src/data/models/weather.dart';

/// Responsible for fetching weather data based on the given location.
abstract interface class IWeatherProvider {
  /// Returns the current [Weather] for the given latitude and longitude.
  Future<Weather> fetchWeather(double lat, double long);
}
