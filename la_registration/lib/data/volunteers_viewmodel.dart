import 'package:flutter/foundation.dart';
import 'dart:async'; // Для асинхронных операций
import '../data/volunteer.dart';
import '../data/volunteers_dao.dart';

class VolunteersViewModel extends ChangeNotifier {
  final VolunteersDao _volunteersDao;

  VolunteersViewModel(this._volunteersDao);

  // Получение всех волонтеров
  Future<List<Volunteer>> getAllVolunteers() =>
      _volunteersDao.getAllVolunteers();

  // Получение волонтеров, которые были отправлены
  Future<List<Volunteer>> getSentVolunteers() =>
      _volunteersDao.getSentVolunteers();

  // Получение волонтеров, которые не были отправлены
  Future<List<Volunteer>> getNotSentVolunteers() =>
      _volunteersDao.getNotSentVolunteers();

  // Получение волонтеров, которые были добавлены в группу
  Future<List<Volunteer>> getAddedToGroupVolunteers() =>
      _volunteersDao.getAddedToGroupVolunteers();

  // Получение волонтеров по статусу и не добавленных в группу
  Future<List<Volunteer>> getVolunteersByStatusAndNotAddedToGroup(
          String status) =>
      _volunteersDao.getVolunteersByStatusAndNotAddedToGroup(status);

  // Вставка нового волонтера в базу данных
  Future<void> insertVolunteer(Volunteer volunteer) async {
    await _volunteersDao.insertVolunteer(volunteer);
    notifyListeners();
  }

  // Обновление данных о волонтере
  Future<void> updateVolunteer(Volunteer volunteer) async {
    await _volunteersDao.updateVolunteer(volunteer);
    notifyListeners();
  }

  // Удаление волонтера
  Future<void> deleteVolunteer(Volunteer volunteer) async {
    await _volunteersDao.deleteVolunteer(volunteer);
    notifyListeners();
  }

  // Удаление всех волонтеров
  Future<void> deleteAllVolunteers() async {
    await _volunteersDao.deleteAllVolunteers();
    notifyListeners();
  }

  // Получение волонтера по уникальному идентификатору
  Future<Volunteer?> getVolunteerById(int id) =>
      _volunteersDao.getVolunteerById(id);

  // Проверка существования волонтера по имени и телефону
  Future<bool> checkForVolunteerExist(String fullName, String phoneNumber) =>
      _volunteersDao.checkForVolunteerExist(fullName, phoneNumber);
}
