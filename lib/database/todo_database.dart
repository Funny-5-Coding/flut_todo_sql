import 'package:flutter_todo_sql/models/todo.dart';
import 'package:flutter_todo_sql/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._initialize();

  static Database? _database;

  TodoDatabase._initialize();

  Future _createDB(Database database, int version) async {
    final userUserameType = 'TEXT PRIMARY KEY NOT NULL';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    await database.execute('''CREATE TABLE $userTable (
      ${UserFields.username} $userUserameType,
      ${UserFields.name} $textType
    )''');

    await database.execute('''CREATE TABLE $todoTable (
      ${TodoFields.username} $textType,
      ${TodoFields.title} $textType,
      ${TodoFields.done} $boolType,
      ${TodoFields.created} $textType,
      FOREIGN KEY (${TodoFields.username}) REFERENCES $userTable (${UserFields.username})
    )''');
  }

  Future _onConfigure(Database database) async {
    await database.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String fileName) async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future close() async {
    final database = await instance.database;
    database!.close();
  }

  Future<Database?> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await _initDB('todo.db');

      return _database;
    }
  }

  Future<User> createUser(User user) async {
    final database = await instance.database;
    await database!.insert(userTable, user.toJson());

    return user;
  }

  Future<User> getUser(String username) async {
    final database = await instance.database;
    final maps = await database!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty)
      return User.fromJson(maps.first);
    else
      throw Exception('This $username not found in the database');
  }

  Future<List<User>> getAllUsers() async {
    final database = await instance.database;
    final result = await database!.query(
      userTable,
      orderBy: '${UserFields.username} ASC',
    );

    return result.map((e) => User.fromJson(e)).toList();
  }

  Future<int> updateUser(User user) async {
    final database = await instance.database;

    return database!.update(
      userTable,
      user.toJson(),
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  Future<int> deleteUser(String username) async {
    final database = await instance.database;

    return database!.delete(
      userTable,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );
  }

  Future<Todo> createTodo(Todo todo) async {
    final database = await instance.database;
    await database!.insert(todoTable, todo.toJson());

    return todo;
  }

  Future<int> toggleTodoDone(Todo todo) async {
    final database = await instance.database;
    todo.done = !todo.done;

    return database!.update(
      todoTable,
      todo.toJson(),
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }

  Future<List<Todo>> getTodos(String username) async {
    final database = await instance.database;
    final result = await database!.query(
      todoTable,
      orderBy: '${TodoFields.created} DESC',
      where: '${TodoFields.username} = ?',
      whereArgs: [username],
    );

    return result.map((e) => Todo.fromJson(e)).toList();
  }

  Future<int> deleteTodo(Todo todo) async {
    final database = await instance.database;

    return database!.delete(
      todoTable,
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }
}
