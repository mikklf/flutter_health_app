import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/logic/helpers/home_stay_helper.dart';
import 'package:intl/intl.dart';

import 'helpers/preprocessor_helper.dart';
import 'interfaces/data_preprocessor.dart';

class SqliteDataPreprocessor implements IDataPreprocessor {
  @override
  Future<List<Map<String, Object?>>> getPreprocessedData() async {
    var heartrates = await _preprocessHeartRate();
    var locations = await _preprocessLocation();
    var steps = await _preprocessSteps();
    var weather = await _preprocessWeather();
    var weights = await _preprocessWeight();

    var combined = await PreprocessorHelper.combineMapsByKey(
        [heartrates, locations, steps, weather, weights], "Date");

    return combined;
  }

  Future<List<Map<String, Object?>>> _preprocessHeartRate() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "heart_rate",
      columns: [
        "DATE(timestamp) as Date, AVG(beats_per_minute) as AverageHeartRate, MIN(beats_per_minute) as MinHeartRate, MAX(beats_per_minute) as MaxHeartRate"
      ],
      groupBy: "DATE(timestamp)",
    );

    return data;
  }

  Future<List<Map<String, Object?>>> _preprocessLocation() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "locations",
      orderBy: "timestamp ASC",
    );

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
      homestayPercent = (homestayPercent * 10).round() / 10;

      processedData.add({
        'Date': date,
        'HomestayPercent': homestayPercent,
      });
    });

    return processedData;
  }

  Future<List<Map<String, Object?>>> _preprocessSteps() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "steps",
      columns: ["DATE(date) as Date, SUM(steps) as Steps"],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    return data;
  }

  // process weather data
  Future<List<Map<String, Object?>>> _preprocessWeather() async {
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
    groupedByDate.forEach((date, dayEntries) {
      dayEntries.removeWhere((element) => element.temperature == null);
      var averageTemperature =
          dayEntries.map((e) => e.temperature!).reduce((a, b) => a + b) /
              dayEntries.length;
      averageTemperature = (averageTemperature * 10).round() / 10;
      var minTemperature =
          dayEntries.map((e) => e.temperature!).reduce((a, b) => a < b ? a : b);
      minTemperature = (minTemperature * 10).round() / 10;
      var maxTemperature =
          dayEntries.map((e) => e.temperature!).reduce((a, b) => a > b ? a : b);
      maxTemperature = (maxTemperature * 10).round() / 10;

      dayEntries.removeWhere((element) => element.temperatureFeelsLike == null);
      var averageTemperatureFeelsLike = dayEntries
              .map((e) => e.temperatureFeelsLike!)
              .reduce((a, b) => a + b) /
          dayEntries.length;
      averageTemperatureFeelsLike =
          (averageTemperatureFeelsLike * 10).round() / 10;

      dayEntries.removeWhere((element) => element.humidity == null);
      var averageHumidity =
          dayEntries.map((e) => e.humidity!).reduce((a, b) => a + b) /
              dayEntries.length;
      averageHumidity = (averageHumidity * 10).round() / 10;

      dayEntries.removeWhere((element) => element.cloudinessPercent == null);
      var averageCloudinessPercent =
          dayEntries.map((e) => e.cloudinessPercent!).reduce((a, b) => a + b) /
              dayEntries.length;
      averageCloudinessPercent = (averageCloudinessPercent * 10).round() / 10;

      dayEntries.removeWhere(
          (element) => element.sunrise == null || element.sunset == null);
      var daylightTime = dayEntries
              .map((e) => e.sunset!.difference(e.sunrise!))
              .reduce((a, b) => a + b)
              .inHours /
          dayEntries.length;

      // Use the most common weather condition as the weather condition for the day
      dayEntries.removeWhere((element) => element.weatherCondition == null);
      var weatherConditions =
          dayEntries.map((e) => e.weatherCondition!).toList();
      var mostCommonWeatherCondition = weatherConditions
          .fold<Map<String, int>>({}, (previousValue, element) {
            previousValue[element] = (previousValue[element] ?? 0) + 1;
            return previousValue;
          })
          .entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      var isRainyOrSnowy = mostCommonWeatherCondition == 'Rain' ||
          mostCommonWeatherCondition == 'Snow';

      processedData.add({
        'Date': date,
        'AverageTemperature': averageTemperature,
        'MinTemperature': minTemperature,
        'MaxTemperature': maxTemperature,
        'HumidityPercent': averageHumidity,
        'CloudinessPercent': averageCloudinessPercent,
        'DaylightTimeInHours': daylightTime,
        'isRainyOrSnowy': isRainyOrSnowy ? 1 : 0,
      });
    });

    return processedData;
  }

  Future<List<Map<String, Object?>>> _preprocessWeight() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "weights",
      columns: ["DATE(date) as Date, AVG(weight) as Weight"],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    return data;
  }
}
