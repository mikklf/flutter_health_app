import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:weather/weather.dart' as open_weather;

class OpenWeatherProvider implements IWeatherProvider {
  @override
  Future<Weather> fetchWeather(double lat, double long) async {
    var weather =
        open_weather.WeatherFactory("d4997e6222de1dec26fe9dc1109f5953");
    var data = await weather.currentWeatherByLocation(lat, long);

    // Convert to our own Weather model
    return Weather(
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
  }
}
