import 'package:flutter/foundation.dart';
import 'package:flutter_health_app/constants.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:weather/weather.dart' as open_weather;

class OpenWeatherProvider implements IWeatherProvider {
  @override
  Future<Weather> fetchWeather(double lat, double long) async {

    // If the API key is DEMO, return a dummy weather object
    if (Constants.openWeatherAPIKey == "DEMO") {
      debugPrint("API is DEMO, Returning dummy weather data");
      return Weather(
        temperature: 20,
        temperatureFeelsLike: 20,
        humidity: 50,
        cloudinessPercent: 50,
        weatherCondition: "Clouds",
        weatherdescription: "scattered clouds",
        latitude: lat,
        longitude: long,
        timestamp: DateTime.now(),
        sunrise: DateTime.now(),
        sunset: DateTime.now(),
      );
    }


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
