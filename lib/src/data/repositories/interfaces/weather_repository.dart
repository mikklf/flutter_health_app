import 'package:flutter_health_app/src/data/models/weather.dart';

abstract interface class IWeatherRepository {
  Future<void> insert(Weather weather);
  Future<Weather?> getLastest();
}
