import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'models/brokerObj.dart';

class DatabaseHelper {
  
  static final _databaseName = "brokers_database.db";
  static final _databaseVersion = 1;

  static final table = 'brokers';
  /*
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'age';
*/
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }
  
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    
    /*await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');*/
          await db.execute('''
          CREATE TABLE brokers(id INTEGER PRIMARY KEY, clientId TEXT,hostname TEXT,portNo TEXT,username TEXT,password TEXT)
          ''');
  }
  
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(BrokerObj brokerObj) async {
    Database db = await instance.database;
    return await db.insert(table, brokerObj.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  Future<List<BrokerObj>> queryAllRows() async {
    Database db = await instance.database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('brokers');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return BrokerObj(
        id: maps[i]['id'],
        clientId: maps[i]['clientId'],
        hostname: maps[i]['hostname'],
        portNo: maps[i]['portNo'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other 
  // column values will be used to update the row.
  Future<int> update(BrokerObj brokerObj) async {
    Database db = await instance.database;
    //int id = row['id'];
    return await db.update(table,
                 brokerObj.toMap(), 
                 where: 'id = ?',
                  whereArgs: [brokerObj.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is 
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}