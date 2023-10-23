import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static const _table = "todos";

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper._internal();

  Future<Database> initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'todolist.db');

    final theDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE 
        IF NOT EXISTS $_table 
        (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT,
          completed INTEGER NOT NULL
        )   
        ''');
  }

  Future<List<Todo>> getAllTodos() async {
    var dbClient = await db;
    var todos = await dbClient!.query(_table);
    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<Todo> getTodoById(int id) async {
    var dbClient = await db;
    var todo = await dbClient!.query(_table, where: 'id = ?', whereArgs: [id]);
    return todo.map((todo) => Todo.fromMap(todo)).single;
  }

  Future<List<Todo>> getTodoByTitle(String title) async {
    var dbClient = await db;
    var todo = await dbClient!
        .query(_table, where: 'title like ?', whereArgs: ["%$title%"]);
    return todo.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<int> insertTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient!.insert(_table, todo.toMap());
  }

  Future<int> updateTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient!
        .update(_table, todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
