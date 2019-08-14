import 'dart:async';
import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'brokers_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE brokers(id INTEGER PRIMARY KEY, clientId TEXT,hostname TEXT,portNo TEXT,portNo TEXT,username TEXT,password TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  Future<void> insertBroker(BrokerObj brokerObj) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'dogs',
      brokerObj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BrokerObj>> brokers() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('brokers');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return BrokerObj(
        id: maps[i]['id'],
        clientId: maps[i]['clientId'],
        hostname: maps[i]['hostname'],
        portNo: maps[i]['hostname'],
        username: maps[i]['hostname'],
        password: maps[i]['password'],
      );
    });
  }

  Future<void> updateBroker(BrokerObj brokerObj) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      brokerObj.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [brokerObj.id],
    );
  }

  Future<void> deleteBroker(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'brokers',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  var fido = BrokerObj(
    id: 0,
    clientId: 'Fido',
    hostname: 'Fido',
    portNo: 'Fido',
    username: 'Fido',
    password: 'Fido',
    
  );

  // Insert a dog into the database.
  await insertBroker(fido);

  // Print the list of dogs (only Fido for now).
  print(await brokers());
/*
  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Print Fido's updated information.
  print(await dogs());

  // Delete Fido from the database.
  await deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
  */
}
