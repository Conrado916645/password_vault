import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const TABLE_NAME = 'password_vault';
  static const COLUMN_ID = 'id';
  static const COLUMN_APPLICATION = 'application';
  static const COLUMN_USERNAME = 'username';
  static const COLUMN_PASSWORD = 'password';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult,
      List<dynamic> params]) {
    print(functionName);
    print(sql);

    if(params != null){
      print(params);
    }

    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
}

  Future<void> createPasswordVaultTable(Database db) async {
    final todoSql = '''CREATE TABLE $TABLE_NAME
    (
      $COLUMN_ID INTEGER PRIMARY KEY,
      $COLUMN_APPLICATION TEXT,
      $COLUMN_USERNAME TEXT,
      $COLUMN_PASSWORD TEXT
    )''';

    await db.execute(todoSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('password_vault_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createPasswordVaultTable(db);
  }
}