import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Класс для работы с базой данных
class DatabaseHelper {
  static const _databaseName = "volunteers.db";
  static const _databaseVersion = 1;

  static const tableVolunteers = 'volunteers';
  static const tableGroups = 'groups';
  static const tableArchivedGroupsVolunteers = 'archived_groups_volunteers';

  // Singleton pattern
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Инициализация базы данных
  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Создание таблиц
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableVolunteers (
        uniqueId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        _index INTEGER NOT NULL,
        fullName TEXT NOT NULL,
        callSign TEXT NOT NULL,
        nickName TEXT NOT NULL,
        region TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        car TEXT NOT NULL,
        isSent TEXT NOT NULL,
        status TEXT NOT NULL,
        notifyThatLeft TEXT NOT NULL,
        timeForSearch TEXT NOT NULL,
        groupId INTEGER,
        FOREIGN KEY(groupId) REFERENCES groups(id) ON UPDATE NO ACTION ON DELETE SET NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableGroups (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        numberOfGroup INTEGER NOT NULL,
        elderOfGroupId INTEGER,
        navigators TEXT NOT NULL,
        walkieTalkies TEXT NOT NULL,
        compasses TEXT NOT NULL,
        lamps TEXT NOT NULL,
        others TEXT NOT NULL,
        task TEXT NOT NULL,
        leavingTime TEXT NOT NULL,
        returnTime TEXT NOT NULL,
        dateOfCreation TEXT NOT NULL,
        groupCallsign TEXT NOT NULL,
        archived TEXT NOT NULL,
        FOREIGN KEY(elderOfGroupId) REFERENCES volunteers(uniqueId) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableArchivedGroupsVolunteers (
        archivedGroupId INTEGER NOT NULL,
        archivedVolunteerId INTEGER NOT NULL,
        PRIMARY KEY(archivedGroupId, archivedVolunteerId),
        FOREIGN KEY(archivedGroupId) REFERENCES groups(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
        FOREIGN KEY(archivedVolunteerId) REFERENCES volunteers(uniqueId) ON UPDATE NO ACTION ON DELETE NO ACTION
      );
    ''');
  }

  // Пример функции для вставки данных в таблицу "volunteers"
  Future<void> insertVolunteer(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert(tableVolunteers, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Пример функции для получения всех волонтеров
  Future<List<Map<String, dynamic>>> getAllVolunteers() async {
    final db = await database;
    return await db.query(tableVolunteers);
  }
}
