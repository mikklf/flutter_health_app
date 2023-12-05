import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';

/// Data extractor for [Weight] data stored inside a SQLite database.
class WeightDataExtractor implements IDataExtractor {
  final IDatabaseHelper _databaseHelper;
  WeightDataExtractor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getData(
      DateTime startTime, DateTime endTime) async {
    var db = await _databaseHelper.getDatabase();

    // Database should only have one entry per day
    // However in case there are multiple entries per day, we take the average
    var data = await db.query(
      "weights",
      columns: ["DATE(date) as Date, AVG(weight) as Weight"],
      where: "date BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    return data;
  }
}
