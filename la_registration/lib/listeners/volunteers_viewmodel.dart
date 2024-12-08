import 'package:flutter/material.dart';
import '../data/volunteer.dart';

class VolunteersViewModel extends ChangeNotifier {
  final List<Volunteer> _volunteers = [];

  List<Volunteer> get volunteers => _volunteers;

  // Получить список активных волонтёров
  List<Volunteer> get activeVolunteers =>
      _volunteers.where((volunteer) => volunteer.status == "Active").toList();

  // Получить список архивных волонтёров
  List<Volunteer> get archivedVolunteers =>
      _volunteers.where((volunteer) => volunteer.status == "Archived").toList();

  // Метод для получения одного волонтёра по ID
  Future<Volunteer> getVolunteerById(int id) async {
    return _volunteers.firstWhere((volunteer) => volunteer.uniqueId == id,
        orElse: () => throw Exception('Volunteer not found'));
  }

  // Метод для получения волонтёров по ID группы
  Future<List<Volunteer>> getVolunteersByGroupId(int id) async {
    return _volunteers.where((volunteer) => volunteer.uniqueId == id).toList();
  }

  // Добавление нового волонтёра
  void insertVolunteer(Volunteer volunteer) {
    _volunteers.add(volunteer);
    notifyListeners();
  }

  // Обновление существующего волонтёра
  void updateVolunteer(Volunteer volunteer) {
    final index =
        _volunteers.indexWhere((v) => v.uniqueId == volunteer.uniqueId);
    if (index != -1) {
      _volunteers[index] = volunteer;
      notifyListeners();
    }
  }

  // Архивирование волонтёра
  void archiveVolunteer(int volunteerId) {
    final index = _volunteers
        .indexWhere((volunteer) => volunteer.uniqueId == volunteerId);
    if (index != -1) {
      _volunteers[index].status = "Archived";
      notifyListeners();
    }
  }

  // Восстановление волонтёра из архива
  void restoreVolunteer(int volunteerId) {
    final index = _volunteers
        .indexWhere((volunteer) => volunteer.uniqueId == volunteerId);
    if (index != -1) {
      _volunteers[index].status = "Active";
      notifyListeners();
    }
  }
}
