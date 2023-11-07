import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/logic/helpers/home_stay_helper.dart';
import 'package:intl/intl.dart';

class DataPreprocessor {

  Future<List<Map<String, Object?>>> preprocessHeartRate() async {
    var db = await SqliteDatabaseHelper().getDatabase();
    // Fetch all the data from the database grouped by day
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
    // Fetch all the data from the database grouped by day
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
    // Fetch all the data from the database grouped by day
    var data = await db.query(
      "steps",
      columns: [
        "DATE(date) as Date, SUM(steps) as Steps"
      ],
      groupBy: "DATE(date)",
    );

    // Handle missing data
    
    return data;
  }

  
  // process weather data
  Future<List<Map<String, Object?>>> preprocessWeather() async {
    var db = await SqliteDatabaseHelper().getDatabase();
    // Fetch all the data from the database grouped by day
    var data = await db.query(
      "weather",
      orderBy: "timestamp ASC",
    );

    var weather = data.map((e) => Location.fromMap(e)).toList();

    // TODO: finish

    // Handle missing data
    return data;
  }

}
