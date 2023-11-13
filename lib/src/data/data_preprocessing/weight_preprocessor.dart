import 'package:flutter_health_app/src/data/data_context/helpers/sqlite_database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';

/// Preprocessor for [Weight] data stored inside a SQLite database.
class WeightPreprocessor implements IDataPreprocessor  {
  @override
  Future<List<Map<String, Object?>>> getPreprocessedData() async {
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
