import 'package:sqflite/sqflite.dart';

abstract interface class IDatabaseHelper {
  Future<Database> getDatabase();
}