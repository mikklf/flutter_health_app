import 'package:flutter_health_app/src/data/models/weather.dart';

/// Responsible for fetching weather data based on the given location.
abstract interface class IWeatherProvider {
  /// Returns the current [Weather] for the given latitude and longitude.
  /// Returns a [Weather] object with default values if some or all of the data is missing.
  Future<Weather> fetchWeather(double lat, double long);
}
