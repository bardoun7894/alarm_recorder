import 'dart:io';

import 'package:alarm_recorder/model/recordModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RegisterDatabaseProvider {
  RegisterDatabaseProvider._();

  static final RegisterDatabaseProvider db =RegisterDatabaseProvider._();

  RecordModel recordModel;
  Database _database;

  Future<Database> get database async {
    if(_database !=null) return _database;
    _database =await getDatabaseInstance();
    return _database;
  }
  Future<Database> getDatabaseInstance() async {
    Directory directory =await getApplicationDocumentsDirectory();
    String path =join(directory.path,"register.db");
    return await openDatabase(path,
        version: 1,onCreate: (Database db,int version)async{
          await db.execute(
            "CREATE TABLE register(id INTEGER PRIMARY KEY, pathRec TEXT,date TEXT,time TEXT)",
          );    }
    );
  }
  Future<List<RecordModel>> getAllRecords() async{
    final db =await database;
    var map =await db.query('register');
    return List.generate(map.length, (i) {
      return RecordModel(
          id:map[i]['id'],
          pathRec:map[i]['pathRec'],
          date: map[i]['date'],
          time:  map[i]['time']);
    });
  }
  Future<int> insertRegister(RecordModel recordModel) async {
    // Get a reference to the database.
    final Database db = await database;
    var raw =await db.insert("register",recordModel.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    print("seccuss");
    return raw;
  }
  Future<RecordModel> getRecordWithId(int id) async{
    final db =await database;
    var response =await db.query("register",where: "id=?",whereArgs: [id]);
    return response.isNotEmpty?recordModel.fromMap(response.first):null;
  }

  deleteRecordWithId(int id) async{
    final db =await database;
    return db.delete("register",where: "id=?",whereArgs: [id]);
  }
  deleteAllRecords() async{
    final db =await database;
    db.delete("register");
  }
  updateNote(RecordModel recordModel) async{
    final db =await database;
    var response=await db.update("register", recordModel.toMap(),where: "id=?",whereArgs: [recordModel.id]);
    return response;
  }







}
