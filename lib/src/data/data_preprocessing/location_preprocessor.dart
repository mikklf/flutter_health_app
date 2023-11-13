import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_health_app/src/logic/helpers/home_stay_helper.dart';
import 'package:intl/intl.dart';


/// Preprocessor for [Location] data stored inside a SQLite database.
class LocationPreprocessor implements IDataPreprocessor {
  @override
  Future<List<Map<String, Object?>>> getPreprocessedData() async {
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

}