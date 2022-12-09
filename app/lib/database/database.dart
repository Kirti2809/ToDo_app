import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/tasksModel.dart';
import '../model/usersModel.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE users(userId INTEGER PRIMARY KEY, userName TEXT NOT NULL)');
    await db.execute('CREATE TABLE tasks(taskId INTEGER PRIMARY KEY, userId INTEGER, task TEXT NOT NULL, status BOOL NOT NULL)');
  }

  Future<int> insertUser(String userName) async {
    final db = await database;
    int userId = await db.insert(
      'users',
      {'userName': userName},
    );
    return userId;
  }

  Future<int> insertTask(String task, int userId) async {
    final db = await database;
    int taskId = await db.insert(
      'tasks',
      {'task' : task, 'userId': userId, 'status': false},
    );
    return taskId;
  }

  Future<List<Map>> findUser(String user) async {
    final db = await database;
    List<Map> resp = await db.query(
      'users',
      columns: null,
      where: 'userName = ?',
      whereArgs: [user],
    );
    return resp;
  }

  Future<List<Map>> findUsers() async {
    final db = await database;
    List<Map> resp = await db.query(
      'users',
      columns: ['userName']
    );
    return resp;
  }

  Future<List<dynamic>> findTasks(int userId) async {
    final db = await database;
    List<dynamic> resp = await db.query(
      'tasks',
      columns: ['task', 'status', 'taskId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return resp;
  }

  Future<void> updateTask(int taskId, int status) async {
    final db = await database;
    int result = await db.update(
      'tasks',
      {'status': status},
      where: 'taskId = ?',
      whereArgs: [taskId]
    );
    result = 1;
    }

  Future<void> deleteTask(int taskId) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> deleteUser(int userId) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
