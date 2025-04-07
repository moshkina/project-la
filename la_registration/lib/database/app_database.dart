import 'package:floor/floor.dart';
import 'package:la_registration/data/groups_dao.dart';
import 'package:la_registration/data/volunteers_dao.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'dart:async'; // Для StreamController
import 'package:sqflite/sqflite.dart' as sqflite; // Для DatabaseExecutor
part 'app_database.g.dart'; // Это укажет на файл, который будет сгенерирован

@Database(version: 1, entities: [Group, Volunteer])
abstract class AppDatabase extends FloorDatabase {
  GroupsDao get groupsDao;
  VolunteersDao get volunteersDao;
}

// Добавьте это в конец файла app_database.dart (перед последней закрывающей скобкой)
class Converter {
  const Converter();
}
