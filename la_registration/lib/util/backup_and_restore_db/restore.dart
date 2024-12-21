import 'dart:convert';

// Интерфейс для обработки завершения работы
abstract class OnWorkFinishListener {
  void onFinished(bool success, String message);
}

// Класс для восстановления данных
class Restore {
  // Метод для преобразования потока в строку
  String convertStreamToString(Stream<List<int>> inputStream) {
    final sb = StringBuffer();
    inputStream.transform(utf8.decoder).forEach((line) {
      sb.write(line);
    });
    return sb.toString();
  }
}

// Вложенный класс для инициализации восстановления
class Init {
  dynamic database; // Указываем тип dynamic
  OnWorkFinishListener? onWorkFinishListener;

  // Установка базы данных (переименовали метод для устранения конфликта имен)
  Init setDatabase(dynamic database) {
    this.database = database;
    return this;
  }

  // Установка слушателя завершения работы (переименовали метод)
  Init setOnWorkFinishListener(OnWorkFinishListener? listener) {
    onWorkFinishListener = listener;
    return this;
  }

  // Выполнение восстановления данных
  Future<void> execute(Stream<List<int>> inputStream) async {
    try {
      if (database == null) {
        onWorkFinishListener?.onFinished(false, "База данных не указана");
        return;
      }

      // Используем метод convertStreamToString из родительского класса Restore
      final restore = Restore();
      final data = restore.convertStreamToString(inputStream);
      final jsonDB = jsonDecode(data);

      for (var table in jsonDB.keys) {
        // Очистка таблицы (замените на вашу логику)
        await database.query("DELETE FROM $table");

        // Вставка новых данных
        var tableData = jsonDB[table];
        for (var row in tableData) {
          var columns = row.keys.toList();
          var values = columns.map((column) => row[column]).toList();

          String query =
              "INSERT INTO $table (${columns.join(', ')}) VALUES (${values.map((value) => value == null ? 'NULL' : "'$value'").join(', ')})";

          // Выполнение запроса на вставку данных
          await database.query(query);
        }
      }

      onWorkFinishListener?.onFinished(true, "Успешно");
    } catch (e) {
      onWorkFinishListener?.onFinished(false, e.toString());
    }
  }
}
