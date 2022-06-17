import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:Notes/Models/note.dart';

class DatabaseHelper{
  static late DatabaseHelper  _databaseHelper; //singleton databasehelper
  static late Database _database;              //singleton database
  String noteTable= 'note_table';
  String colId = 'id';
  String colTitle= 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance(); //named constructor to create instance of DatabaseHelper

  factory DatabaseHelper()
  {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();  //this is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database==null)
      {
        _database= await initializeDatabase();
      }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory= await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    
    var notesdatabase= openDatabase(path, version: 1, onCreate: _createDB);
    return notesdatabase;
  }
  void _createDB (Database db, int newVersion) async{
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription Text, $colPriority INTEGER, $colDate TEXT)');
  }

  //fetch operation to get all note objects from database
  Future<List<Map<String,dynamic>>>  getNoteMapList() async{
    Database db= await this.database;
    
    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC'); //raw query fn
    var result = await db.query(noteTable,orderBy: ' $colPriority ASC'); // helper func (both work inn the same way
    return result;
  }

  // insert operation to insert a note object to database
  Future<int> Insertnote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
   // update operation to update a note object and save it in database
  Future<int> updatenote(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),where: '$colId =?' , whereArgs: [note.id] );
    return result;
  }

  //delete operation to delete a note object from database
  Future<int> deletenote(int id) async{
    var db = await this.database;
    var result = await db.rawDelete('DELET FROM $noteTable WHERE $colId= $id');
    return result;
  }
  // get the number of objects in database( no. of records)
  Future<int> getcount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x= await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int ?result = Sqflite.firstIntValue(x);
    return result!;
  }
  //get the 'Map List' [ List<Map> ] and convert it to 'Note List' [List<Note>]
  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = <Note>[];

    for(int i=0;i< count;i++)
      {
        noteList.add(Note.fromMap(noteMapList[i]));
      }
      return noteList;

  }
}