import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseHelper {
  final String _databaseName = "health_app_database.db";

  Future<Database> getDatabase() async {
    return openDatabase(
      await _getSqliteDatabasePath(),
      onCreate: _onDatabaseCreate,
      version: 1,
    );
  }

  Future<void> _onDatabaseCreate(Database db, int version) {
    return db.execute(
      """
      CREATE TABLE survey_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, survey_id TEXT, start_date TEXT, end_date TEXT, result TEXT)
      """,
    );
  }

  Future<String> _getSqliteDatabasePath() async {
    return join(await getDatabasesPath(), _databaseName);
  }
}
