import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';

import '../data_context/interfaces/weather_datacontext.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherDataContext _weatherProvider;

  WeatherRepository(this._weatherProvider);
  
  @override
  Future<void> insert(Weather weather) async {
    await _weatherProvider.insert(weather.toMap());
  }

  @override
  Future<Weather?> getLastest () async {
    var result = await _weatherProvider.getLastest();

    if (result == null) {
      return null;
    }

    return Weather.fromMap(result);
  }
}