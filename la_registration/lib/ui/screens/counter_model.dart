import 'package:flutter/foundation.dart';

class CounterModel extends ChangeNotifier {
  int _count = 0;

  // Геттер для получения текущего значения
  int get count => _count;

  // Метод для увеличения счетчика
  void increment() {
    _count++;
    notifyListeners(); // Уведомляем слушателей о том, что данные изменились
  }
}
