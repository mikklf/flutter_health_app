import 'package:flutter_health_app/src/data/data_context/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'interfaces/survey_entry_datacontext.dart';

/// SQLite implementation of the [ISurveyEntryDataContext].
class SurveyEntryDataContext implements ISurveyEntryDataContext {
  final IDatabaseHelper _databaseHelper;
  final String _tableName = "survey_entries";

  SurveyEntryDataContext(this._databaseHelper);

  @override
  Future<void> insert(Map<String, Object?> values) async {
    final Database db = await _databaseHelper.getDatabase();
    
    await db.insert(
      _tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// Get the last entry of a survey with the given [surveyId]. Returns null if no entry is found.
  @override
  Future<Map<String, dynamic>?> getLastEntryOfType(final String surveyId) async {
    final Database db = await _databaseHelper.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "survey_id = ?",
      whereArgs: [surveyId],
      orderBy: "id DESC",
      limit: 1,
    );
    
    return maps.firstOrNull;
  }
}