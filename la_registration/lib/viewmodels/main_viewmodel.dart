import 'package:flutter/foundation.dart';
import 'dart:io';
import '../data/main_database.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();

  Future<void> backupDatabase(String filePath) async {
    final dbPath =
        await MainDatabase.getDatabasePath('app_database.db'); // Получение пути
    final backupFile = File(filePath);
    await File(dbPath).copy(backupFile.path);
  }

  Future<void> restoreDatabase(String filePath) async {
    final dbPath =
        await MainDatabase.getDatabasePath('app_database.db'); // Получение пути
    final backupFile = File(filePath);
    if (await backupFile.exists()) {
      await backupFile.copy(dbPath);
      notifyListeners();
    }
  }
}
