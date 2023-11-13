import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';

/// Preprocessor for [Steps] data stored inside a SQLite database.
class StepsPreprocessor implements IDataPreprocessor {
  @override
  Future<List<Map<String, Object?>>> getPreprocessedData() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "steps",
      columns: ["DATE(date) as Date, SUM(steps) as Steps"],
      groupBy: "DATE(date)",
      orderBy: "date ASC",
    );

    return data;
  }

}