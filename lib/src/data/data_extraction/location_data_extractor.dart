import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/logic/helpers/home_stay_helper.dart';
import 'package:intl/intl.dart';

/// Preprocessor for [Location] data stored inside a SQLite database.
class LocationDataExtractor implements IDataExtractor {
  final IDatabaseHelper _databaseHelper;
  LocationDataExtractor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getData(
      DateTime startTime, DateTime endTime) async {
    var db = await _databaseHelper.getDatabase();

    var data = await db.query(
      "locations",
      where: "timestamp BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
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
}
