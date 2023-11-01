import 'package:flutter_health_app/src/data/models/weather.dart';

abstract interface class IWeatherProvider {
  Future<Weather> fetchWeather(double lat, double long);
}
