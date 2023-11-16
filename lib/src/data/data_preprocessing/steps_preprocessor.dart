import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';

/// Preprocessor for [Steps] data stored inside a SQLite database.
class StepsPreprocessor implements IDataPreprocessor {
  final IDatabaseHelper _databaseHelper;
  StepsPreprocessor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getPreprocessedData(
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
