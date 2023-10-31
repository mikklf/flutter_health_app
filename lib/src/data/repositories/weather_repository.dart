import 'package:flutter_health_app/domain/interfaces/weather_provider.dart';
import 'package:flutter_health_app/domain/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherProvider _weatherProvider;

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