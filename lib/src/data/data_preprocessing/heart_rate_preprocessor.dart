import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';

import '../data_context/helpers/sqlite_database_helper.dart';

/// Preprocessor for [HeartRate] data stored inside a SQLite database.
class HeartRatePreprocessor implements IDataPreprocessor {
  @override
  Future<List<Map<String, Object?>>> getPreprocessedData() async {
    var db = await SqliteDatabaseHelper().getDatabase();

    var data = await db.query(
      "heart_rate",
      columns: [
        "DATE(timestamp) as Date, AVG(beats_per_minute) as AverageHeartRate, MIN(beats_per_minute) as MinHeartRate, MAX(beats_per_minute) as MaxHeartRate"
      ],
      groupBy: "DATE(timestamp)",
    );

    return data;
  }

}