import 'dart:async';
import 'package:floor/floor.dart' as floor; // Псевдоним для аннотации
import 'package:sqflite/sqflite.dart' as sqflite; // Псевдоним для sqflite
import 'package:path/path.dart'; // Для работы с путями
import '../data/group.dart';
import '../data/volunteer.dart';
import 'archived_groups_volunteers.dart';
import '../converters/converter.dart';
import 'groups_dao.dart';
import 'main_dao.dart';

@floor.Database(
    version: 1, entities: [Group, Volunteer, ArchivedGroupsVolunteers])
@floor.TypeConverters([Converter])
abstract class MainDatabase extends floor.FloorDatabase {
  GroupsDao get groupsDao;
  MainDao get mainDao;

  // Метод для получения пути к базе данных
  static Future<String> getDatabasePath(String dbName) async {
    final databasesPath =
        await sqflite.getDatabasesPath(); // Используем sqflite
    return join(databasesPath, dbName);
  }
}
