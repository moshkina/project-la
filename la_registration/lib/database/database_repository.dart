import 'package:floor/floor.dart';
import 'package:flutter/services.dart';
import '../data/group.dart';
import '../data/main_dao.dart';
import '../data/groups_dao.dart';
import '../data/volunteers_dao.dart';
import '../data/main_database.dart'; // Ваши файлы базы данных
import '../database/database_helper.dart';

class DatabaseRepository {
  static late MainDatabase _database;

  // Инициализация базы данных
  static Future<void> initDatabase() async {
    _database ??=
        await $FloorMainDatabase.databaseBuilder('main_database.db').build();
  }

  // Геттеры для DAO
  static GroupsDao get groupsDao => _database.groupsDao;
  static VolunteersDao get volunteersDao => _database.volunteersDao;
  static MainDao get mainDao => _database.mainDao;
}
