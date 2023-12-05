import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';

/// Preprocessor for [HeartRate] data stored inside a SQLite database.
class HeartRateDataExtractor implements IDataExtractor {
  final IDatabaseHelper _databaseHelper;
  HeartRateDataExtractor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getData(
      DateTime startTime, DateTime endTime) async {
    var db = await _databaseHelper.getDatabase();

    var data = await db.query(
      "heart_rate",
      columns: [
        "DATE(timestamp) as Date, AVG(beats_per_minute) as AverageHeartRate, MIN(beats_per_minute) as MinHeartRate, MAX(beats_per_minute) as MaxHeartRate"
      ],
      where: "timestamp BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
      groupBy: "DATE(timestamp)",
    );

    return data;
  }
}
