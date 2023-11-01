import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';

import '../data_context/interfaces/weather_datacontext.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherDataContext _weatherContext;

  WeatherRepository(this._weatherContext);
  
  @override
  Future<void> insert(Weather weather) async {
    await _weatherContext.insert(weather.toMap());
  }

  @override
  Future<Weather?> getLastest () async {
    var result = await _weatherContext.getLastest();

    if (result == null) {
      return null;
    }

    return Weather.fromMap(result);
  }


}