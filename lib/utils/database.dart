 import 'package:alarm_recorder/model/Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
    Database database;
  initDB() async{

      database = await openDatabase(
          join(await getDatabasesPath(), 'note.db'),
          onCreate: (db, version) async {
            await db.execute(
              "CREATE TABLE note(id INTEGER PRIMARY KEY, title TEXT, description TEXT,date TEXT,time TEXT)",
            );
          }, version: 1
      );

  }
  Future<void> insertNote(Note note) async {
    // Get a reference to the database.
    final Database db = await initDB();
    await db.insert(
      'note',
      note.toMap(),
    );
    print("seccuss");
    print("-------------------------------------------------");
  }
  Future<List<Note>> notes() async {
    // Get a reference to the database.
    final Database db = await initDB();
    // Query the table for all The notes.
    final List<Map<String, dynamic>> maps = await db.query('note');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Note(
          maps[i]['id'],
         maps[i]['title'],
         maps[i]['description'],
         maps[i]['date'],
         maps[i]['time']
      );
    });
  }
  Future<void> updateDog(Note note) async {
    // Get a reference to the database.
    final db = await initDB().database;
    // Update the given Dog.
    await db.update(
      'notes',
      note.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
  }
  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await initDB().database;
    // Remove the Note from the database.
    await db.delete(
      'notes',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Note's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }








}
