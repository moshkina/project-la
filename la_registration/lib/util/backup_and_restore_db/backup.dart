import 'dart:convert';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class Backup {
  static const _sqliteTables = [
    'android_metadata',
    'room_master_table',
    'sqlite_sequence',
  ];
  static const _stringForNullValue = '!!!string_for_null_value!!!';

  static Future<void> execute({
    required Database database,
    required File outputFile,
    required void Function(bool success, String message) onFinished,
  }) async {
    try {
      // Получение всех таблиц в базе данных
      final tables = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );

      final dbBuilder = <String, dynamic>{};

      for (var table in tables) {
        final tableName = table['name'] as String?;
        if (tableName == null || _sqliteTables.contains(tableName)) continue;

        // Получение строк таблицы
        final rows = await database.rawQuery("SELECT * FROM $tableName");
        dbBuilder[tableName] = rows.map((row) {
          return row
              .map((key, value) => MapEntry(key, value ?? _stringForNullValue));
        }).toList();
      }

      // Конвертация в JSON
      final jsonDB = jsonEncode(dbBuilder);

      // Запись в файл
      final sink = outputFile.openWrite();
      sink.write(jsonDB);
      await sink.flush();
      await sink.close();

      onFinished(true, "Backup completed successfully.");
    } catch (e) {
      onFinished(false, "Error during backup: $e");
    }
  }
}
