import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

abstract class BaseModel {
  Map<String, dynamic> toMap();

  BaseModel initFromMap(Map params);

}

class DatabaseManager {
  Database database;

  static DatabaseManager _shared;

  factory DatabaseManager() {
    return sharedInstance();
  }

  DatabaseManager._internal();

  static DatabaseManager sharedInstance() {
    if (_shared == null) {
      _shared = DatabaseManager._internal();
    }
    return _shared;
  }

  // Init
  Future<void> getDB() async {
    if (this.database != null) {
      return;
    }

    String path = await getDatabasesPath();

    this.database = await openDatabase(join(path, 'fundManager.db'), version: 1,
        onCreate: (db, version) async {
      // 创建表
      // Item
      await db.execute('''
          CREATE TABLE item (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            type TEXT, 
            date TEXT, 
            money DOUBLE, 
            memo TEXT,
            category TEXT)
          ''');
    });
  }

  // Insert
  Future<int> insert(String tableName, BaseModel model,
      {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace}) async {
    await this.getDB();
    int index = await this
        .database
        .insert(tableName, model.toMap(), conflictAlgorithm: conflictAlgorithm);
    return index;
  }

  // Query
  Future<List<Map<String, dynamic>>> query(String tableName,
      {bool distinct,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    await this.getDB();
    List<Map<String, dynamic>> results = await this.database.query(tableName,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);

//    List<BaseModel> models = new List<BaseModel>();
//
//    for (Map map in results) {
//      BaseModel model = new BaseModel();
//      model = model.initFromMap(map);
//      models.add(model);
//    }

    return results;
  }

  // Update
  Future<int> update(String tableName, Map<String, dynamic> values,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace}) async {
    await this.getDB();
    int index = await this.database.update(tableName, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);

    return index;
  }

  // Delete
  Future<int> delete(String tableName,
      {String where, List<dynamic> whereArgs}) async {
    await this.getDB();
    int index = await this
        .database
        .delete(tableName, whereArgs: whereArgs, where: where);
    return index;
  }

  // DeleteAll
  void deleteAll(String tableName) async {
    await this.getDB();
    await this.database.execute("truncate table $tableName");
  }

  // Close
  void close() async {
    if (this.database != null && this.database.isOpen) {
      await this.database.close();
    }
    this.database = null;
  }
}
