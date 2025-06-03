import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/group.dart';
import '../data/groups_dao.dart';
import '../data/volunteer.dart';
import '../data/volunteers_dao.dart';
import '../data/group_callsign.dart';

class GroupsViewModel extends ChangeNotifier {
  final GroupsDao _groupsDao;

  GroupsViewModel(this._groupsDao);
  List<Group> _groups = [];
  List<Group> get groups => _groups;
  Future<List<Group>> getAllGroups() => _groupsDao.getAllGroups();
  final Map<GroupCallsigns, List<Group>> _groupsByCallsign = {};
 



  List<Group> getGroupsForCallsign(GroupCallsigns callsign) {
  return _groupsByCallsign[callsign] ?? [];
}


Future<void> loadGroupsByCallsign(GroupCallsigns callsign) async {
  final groups = await _groupsDao.getGroupsByCallsignNotArchived(callsign);
  _groupsByCallsign[callsign] = groups;
  notifyListeners();
}





  Future<List<Group>> getGroupByCallsignNotArchived(String groupCallsign) {
    final callsign = GroupCallsigns.fromString(groupCallsign);
    if (callsign == null) {
      throw ArgumentError('Invalid groupCallsign: $groupCallsign');
    }
    return _groupsDao.getGroupsByCallsignNotArchived(callsign);
  }

  Future<List<Group>> getActiveGroups(String groupCallsign) async {
    final groups = await _groupsDao.getAllGroups();
    return groups
        .where((group) => group.groupCallsign.name == groupCallsign)
        .toList();
  }

  Future<List<Group>> getGroupByCallsignArchived(String groupCallsign) {
    final callsign = GroupCallsigns.fromString(groupCallsign);
    if (callsign == null) {
      throw ArgumentError('Invalid groupCallsign: $groupCallsign');
    }
    return _groupsDao.getGroupsByCallsignArchived(callsign);
  }

  Future<int?> getLastNumberOfGroup(String groupCallsign) {
    final callsign = GroupCallsigns.fromString(groupCallsign);
    if (callsign == null) {
      throw ArgumentError('Invalid groupCallsign: $groupCallsign');
    }
    return _groupsDao.getLastNumberOfGroupByCallsign(callsign);
  }

  Future<List<Group>> getArchivedGroups(String groupCallsign) {
    final callsign = GroupCallsigns.fromString(groupCallsign);
    if (callsign == null) {
      throw ArgumentError('Invalid groupCallsign: $groupCallsign');
    }
    return _groupsDao.getGroupsByCallsignArchived(callsign);
  }

  Future<int> insertGroup(Group group) async {
    final id = await _groupsDao.insertGroup(group);
    notifyListeners();
    return id;
  }

  Future<int> updateGroup(Group group) async {
    final id = await _groupsDao.updateGroup(group);
    notifyListeners();
    return id;
  }

  Future<int> deleteGroup(Group group) async {
    final id= await _groupsDao.deleteGroup(group);
    notifyListeners();
    return id;
  }

  Future<void> deleteAllGroups() async {
    await _groupsDao.deleteAllGroups();
    notifyListeners();
  }

  Future<Group?> getGroupById(int id) => _groupsDao.getGroupById(id);

  Future<Group?> getArchivedGroupById(int id) =>
      _groupsDao.getArchivedGroupById(id);

  Future<int?> getGroupIdByNumber(int numberOfGroup) =>
      _groupsDao.getGroupIdByNumber(numberOfGroup);
}

class VolunteersViewModel extends ChangeNotifier {
  final VolunteersDao _volunteersDao;
  List<Volunteer> _volunteers = [];

  List<Volunteer> get volunteers => _volunteers;

  VolunteersViewModel(this._volunteersDao) {
    loadVolunteers();
  }
 Future<void> loadVolunteers() async {
  _volunteers = await _volunteersDao.getAllVolunteers();
  print("Загружено волонтёров: ${_volunteers.length}");
  for (var v in _volunteers) {
    print(v);
  }
  notifyListeners();
}
  Future<void> markAllUnsentAsSent() async {
    final unsent = _volunteers.where((v) => !v.isSent).toList();
    for (final v in unsent) {
      final updated = v.copyWith(isSent: true);
      await _volunteersDao.updateVolunteer(updated);
    }
    await loadVolunteers();
  }



String formatVolunteers(List<Volunteer> volunteers) {
  return volunteers.map((v) => '''
ФИО: ${v.fullName}
Позывной: ${v.callSign}
Ник: ${v.nickName}
Регион: ${v.region}
Телефон: ${v.phoneNumber}
Авто: ${v.car}
Группа: ${v.groupId ?? '-'}
Статус: ${v.status}
Время: ${v.timeForSearch ?? ''}
''').join('\n====================\n');
}



  Future<void> sendDepartedVolunteersToInformant() async {
    final departedVolunteers = _volunteers
        .where((v) => v.status == 'уехал')
        .toList();


    notifyListeners(); // обновляет UI
  }



  // Получение всех волонтеров
  Future<List<Volunteer>> getAllVolunteers() =>
      _volunteersDao.getAllVolunteers();

  Future<List<Volunteer>> getVolunteersByGroupId(int groupId) {
    return _volunteersDao.getVolunteersByGroupId(groupId);
  }

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
    await loadVolunteers(); // Обновляем список и уведомляем
  }

  // Обновление данных о волонтере
  Future<void> updateVolunteer(Volunteer volunteer) async {
    await _volunteersDao.updateVolunteer(volunteer);
    await loadVolunteers();
  }

  // Удаление волонтера
  Future<void> deleteVolunteer(Volunteer volunteer) async {
    await _volunteersDao.deleteVolunteer(volunteer);
    await loadVolunteers();
  }

  // Удаление всех волонтёров
  Future<void> deleteAllVolunteers() async {
    await _volunteersDao.deleteAllVolunteers();
    await loadVolunteers();
  }

  // Получение волонтера по уникальному идентификатору
  Future<Volunteer?> getVolunteerById(int id) =>
      _volunteersDao.getVolunteerById(id);

// Получить список активных волонтёров
  Future<List<Volunteer>> get activeVolunteers async {
    final volunteers = await _volunteersDao.getAllVolunteers();
    return volunteers
        .where((volunteer) => volunteer.status == "Active")
        .toList();
  }

// Получить список архивных волонтёров
  Future<List<Volunteer>> get archivedVolunteers async {
    final volunteers = await _volunteersDao.getAllVolunteers();
    return volunteers
        .where((volunteer) => volunteer.status == "Archived")
        .toList();
  }

  // Архивировать волонтёра
  Future<void> archiveVolunteer(int volunteerId) async {
    final volunteer = await getVolunteerById(volunteerId);
    if (volunteer != null) {
      volunteer.status = "Archived";
      await updateVolunteer(volunteer);
    }
  }

  // Восстановить волонтёра
  Future<void> restoreVolunteer(int volunteerId) async {
    final volunteer = await getVolunteerById(volunteerId);
    if (volunteer != null) {
      volunteer.status = "Active";
      await updateVolunteer(volunteer);
    }
  }
}
