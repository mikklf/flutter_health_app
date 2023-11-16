import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/survey_objects/result_parsers/kellner_result_parser.dart';

/// Preprocessor for [KellnerSurvey] results stored inside a SQLite database.
class KellnerResultPreprocessor implements IDataPreprocessor {
  final IDatabaseHelper _databaseHelper;
  KellnerResultPreprocessor(this._databaseHelper);

  @override
  Future<List<Map<String, Object?>>> getPreprocessedData(
      DateTime startTime, DateTime endTime) async {
    var db = await _databaseHelper.getDatabase();

    var data = await db.query(
      "survey_entries",
      columns: ["Date(date) as Date, result as Result"],
      where: "survey_id = 'kellner' AND date BETWEEN ? AND ?",
      whereArgs: [startTime.toString(), endTime.toString()],
      orderBy: "date ASC",
    );

    List<Map<String, dynamic>> processedData = [];

    for (var element in data) {
      var result = element["Result"] as String;

      var parsedResult = KellnerResultParser.parse(result);

      processedData.add({
        "Date": element["Date"],
        "DepressionScaleScore": parsedResult["depressionScaleScore"],
        "DepressionSubscaleScore": parsedResult["depressionSubscaleScore"],
        "ContentmentSubscaleScore": parsedResult["contentmentSubscaleScore"],
      });
    }

    return processedData;
  }
}
