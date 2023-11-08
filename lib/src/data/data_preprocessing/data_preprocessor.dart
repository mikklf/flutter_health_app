import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/logic/helpers/home_stay_helper.dart';
import 'package:intl/intl.dart';

class DataPreprocessor {
  Future<List<Map<String, Object?>>> preprocessHeartRate() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "heart_rate",
      columns: [
        "DATE(timestamp) as Date, AVG(beats_per_minute) as AverageHeartRate, MIN(beats_per_minute) as MinHeartRate, MAX(beats_per_minute) as MaxHeartRate"
      ],
      groupBy: "DATE(timestamp)",
    );

    // Handle missing data

    return data;
  }

  Future<List<Map<String, Object?>>> preprocessLocation() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "locations",
      orderBy: "timestamp ASC",
    );

    // convert to a list of Location objects
    var locations = data.map((e) => Location.fromMap(e)).toList();

    // Group the locations by date
    Map<String, List<Location>> groupedByDate = {};
    for (var location in locations) {
      var formattedDate = DateFormat('yyyy-MM-dd').format(location.timestamp);
      groupedByDate.putIfAbsent(formattedDate, () => []).add(location);
    }

    List<Map<String, dynamic>> processedData = [];
    groupedByDate.forEach((date, locations) {
      var homestayPercent = HomeStayHelper.calculateHomestay(locations);

      processedData.add({
        'Date': date,
        'HomestayPercent': homestayPercent,
      });
    });

    return processedData;
  }

  Future<List<Map<String, Object?>>> preprocessSteps() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "steps",
      columns: ["DATE(date) as Date, SUM(steps) as Steps"],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    // Handle missing data

    return data;
  }

  // process weather data
  Future<List<Map<String, Object?>>> preprocessWeather() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "weather",
      orderBy: "timestamp ASC",
    );

    var weather = data.map((e) => Weather.fromMap(e)).toList();

    // Group the weather by date
    Map<String, List<Weather>> groupedByDate = {};
    for (var w in weather) {
      var formattedDate = DateFormat('yyyy-MM-dd').format(w.timestamp);
      groupedByDate.putIfAbsent(formattedDate, () => []).add(w);
    }

    List<Map<String, dynamic>> processedData = [];
    groupedByDate.forEach((date, weather) {
      weather.removeWhere((element) => element.temperature == null);
      var averageTemperature =
          weather.map((e) => e.temperature!).reduce((a, b) => a + b) /
              weather.length;
      averageTemperature = (averageTemperature * 10).round() / 10;

      weather.removeWhere((element) => element.temperatureFeelsLike == null);
      var averageTemperatureFeelsLike =
          weather.map((e) => e.temperatureFeelsLike!).reduce((a, b) => a + b) /
              weather.length;
      averageTemperatureFeelsLike =
          (averageTemperatureFeelsLike * 10).round() / 10;

      weather.removeWhere((element) => element.humidity == null);
      var averageHumidity =
          weather.map((e) => e.humidity!).reduce((a, b) => a + b) /
              weather.length;
      averageHumidity = (averageHumidity * 10).round() / 10;

      weather.removeWhere((element) => element.cloudinessPercent == null);
      var averageCloudinessPercent =
          weather.map((e) => e.cloudinessPercent!).reduce((a, b) => a + b) /
              weather.length;
      averageCloudinessPercent =
          (averageCloudinessPercent * 10).round() / 10;

      weather.removeWhere(
          (element) => element.sunrise == null || element.sunset == null);
      var daylightTime = weather
              .map((e) => e.sunset!.difference(e.sunrise!))
              .reduce((a, b) => a + b)
              .inHours /
          weather.length;

      // Use the most common weather condition as the weather condition for the day
      weather.removeWhere((element) => element.weatherCondition == null);
      var weatherConditions = weather.map((e) => e.weatherCondition!).toList();
      var mostCommonWeatherCondition = weatherConditions
          .fold<Map<String, int>>({}, (previousValue, element) {
            previousValue[element] = (previousValue[element] ?? 0) + 1;
            return previousValue;
          })
          .entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      processedData.add({
        'Date': date,
        'AverageTemperature': averageTemperature,
        'AverageTemperatureFeelsLike': averageTemperatureFeelsLike,
        'AverageHumidity': averageHumidity,
        'AverageCloudinessPercent': averageCloudinessPercent,
        'DaylightTimeInHours': daylightTime,
        'WeatherCondition': mostCommonWeatherCondition,
      });
    });

    return processedData;
  }

  Future<List<Map<String, Object?>>> preprocessWeight() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "weights",
      columns: ["DATE(date) as Date, AVG(weight) as Weight"],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    return data;

  }


  static Future<List<Map<String, Object?>>> combine(List<List<Map<String, Object?>>> mapsList) async {

    // Combine the maps
    var combinedMaps = <String, Map<String, Object?>>{};
    for (var maps in mapsList) {
      for (var map in maps) {
        var date = map['Date'] as String;
        combinedMaps.putIfAbsent(date, () => {}).addAll(map);
      }
    }

    // Convert to a list
    var combinedList = combinedMaps.values.toList();

    // Sort the list
    combinedList.sort((a, b) => a['Date'].toString().compareTo(b['Date'].toString()));

    return combinedList;

  }


}
