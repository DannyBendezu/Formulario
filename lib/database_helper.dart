import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'flutterjunction.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nombre TEXT, apellidos TEXT, fechanaci TEXT, direccion TEXT, estado TEXT, credito TEXT)""");
  }

// id: the id of a item
// nombre, apellidos, fechanaci, direcion, estado, credito: name and description of  activity
// created_at: the time that the item was created. It will be automatically handled by SQLite
  // Create new item
  static Future<int> createItem(
      String? nombre,
      String? apellidos,
      String? fechanaci,
      String? direccion,
      String? estado,
      String? credito) async {
    final db = await DatabaseHelper.db();

    final data = {
      'title': nombre,
      'description': apellidos,
      // ignore: equal_keys_in_map
      'title': fechanaci,
      // ignore: equal_keys_in_map
      'description': direccion,
      // ignore: equal_keys_in_map
      'title': estado,
      // ignore: equal_keys_in_map
      'description': credito,
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;

    // When a UNIQUE constraint violation occurs,
    // the pre-existing rows that are causing the constraint violation
    // are removed prior to inserting or updating the current row.
    // Thus the insert or update always occurs.
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String nombre,
      String apellidos,
      String fechanaci,
      String dirreccion,
      String estado,
      String credito) async {
    final db = await DatabaseHelper.db();

    final data = {
      'title': nombre,
      'description': apellidos,
      // ignore: equal_keys_in_map
      'title': fechanaci,
      // ignore: equal_keys_in_map
      'description': dirreccion,
      // ignore: equal_keys_in_map
      'title': estado,
      // ignore: equal_keys_in_map
      'description': credito,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}