import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_extraction/interfaces/data_extractor.dart';

/// Data extractor for [Steps] data stored inside a SQLite database.
class StepsDataExtractor implements IDataExtractor {
  final IDatabaseHelper _databaseHelper;
  StepsDataExtractor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getData(
      DateTime startTime, DateTime endTime) async {
    var db = await _databaseHelper.getDatabase();

    var data = await db.query(
      "steps",
      columns: ["DATE(date) as Date, SUM(steps) as Steps"],
      where: "date BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    return data;
  }
}
