import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:intl/intl.dart';

/// Data extractor for [Weather] data stored inside a SQLite database.
class WeatherDataExtractor implements IDataExtractor {
  final IDatabaseHelper _databaseHelper;
  WeatherDataExtractor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getData(
      DateTime startTime, DateTime endTime) async {
    var db = await _databaseHelper.getDatabase();

    var data = await db.query(
      "weather",
      where: "timestamp BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
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

      processedData.add({
        'Date': date,
        'AverageTemperature': averageTemperature,
        'CloudinessPercent': averageCloudinessPercent,
        'DaylightTimeInHours': daylightTime,
        'IsRaining': mostCommonWeatherCondition == 'Rain' ? 1 : 0,
        'IsSnowing': mostCommonWeatherCondition == 'Snow' ? 1 : 0,
      });
    });

    return processedData;
  }
}
