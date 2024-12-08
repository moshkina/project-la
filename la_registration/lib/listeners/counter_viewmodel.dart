import 'package:flutter/material.dart';

// Модель данных (ViewModel)
class CounterViewModel with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  // Увеличение счетчика
  void increment() {
    _count++;
    notifyListeners(); // Уведомляем слушателей об изменении состояния
  }

  // Уменьшение счетчика
  void decrement() {
    _count--;
    notifyListeners(); // Уведомляем слушателей об изменении состояния
  }

  // Сброс счетчика
  void reset() {
    _count = 0;
    notifyListeners(); // Уведомляем слушателей об изменении состояния
  }
}
