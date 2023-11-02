import 'package:flutter_health_app/src/data/models/weather.dart';

abstract interface class IWeatherRepository {
  /// Inserts the given weather into the database.
  Future<void> insert(Weather weather);

  /// Returns the latest weather entry based on the timestamp.
  /// Returns null if no weather is found.
  Future<Weather?> getLastest();
}
