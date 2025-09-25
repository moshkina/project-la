import 'package:flutter/foundation.dart';
import '../data/group.dart';
import '../data/groups_dao.dart';
import '../data/volunteer.dart';
import '../data/volunteers_dao.dart';
import '../data/group_callsign.dart';

class GroupsViewModel extends ChangeNotifier {
  final GroupsDao _groupsDao;
  List<Group> _groups = [];

  List<Group> get groups => _groups;

  GroupsViewModel(this._groupsDao) {
    _loadAllGroups();
  }

  Future<void> _loadAllGroups() async {
    _groups = await _groupsDao.getAllGroups();
    notifyListeners();
  }

  List<Group> getGroupsForCallsign(GroupCallsigns callsign) {
    return _groups.where((group) => group.groupCallsign == callsign).toList();
  }

  Future<void> loadGroupsByCallsign(GroupCallsigns callsign) async {
    await _loadAllGroups();
  }

  Future<List<Group>> getGroupByCallsignNotArchived(String groupCallsign) {
    final callsign = GroupCallsigns.fromString(groupCallsign);
    if (callsign == null) {
      throw ArgumentError('Invalid groupCallsign: $groupCallsign');
    }
    return _groupsDao.getGroupsByCallsignNotArchived(callsign);
  }

  Future<List<Group>> getActiveGroups(String groupCallsign) async {
    await _loadAllGroups();
    return _groups
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
    await _loadAllGroups();
    return id;
  }

  Future<int> updateGroup(Group group) async {
    final id = await _groupsDao.updateGroup(group);
    await _loadAllGroups();
    return id;
  }

  Future<int> deleteGroup(Group group) async {
    final id = await _groupsDao.deleteGroup(group);
    await _loadAllGroups();
    return id;
  }

  Future<void> deleteArchivedGroups() async {
    await _groupsDao.deleteArchivedGroups();
    await _loadAllGroups();
  }

  Future<Group?> getGroupById(int id) => _groupsDao.getGroupById(id);

  Future<Group?> getArchivedGroupById(int id) =>
      _groupsDao.getArchivedGroupById(id);

  Future<int?> getGroupIdByNumber(int numberOfGroup) =>
      _groupsDao.getGroupIdByNumber(numberOfGroup);
}

class VolunteersViewModel extends ChangeNotifier {
  final VolunteersDao _volunteersDao;
  final GroupsDao _groupsDao;
  List<Volunteer> _volunteers = [];
  String _searchQuery = '';

  List<Volunteer> get volunteers => _filterVolunteers(_volunteers);
  String get searchQuery => _searchQuery;

  VolunteersViewModel(this._volunteersDao, this._groupsDao) {
    loadVolunteers();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<List<Volunteer>> getVolunteersWithoutGroup() async {
    final all = await _volunteersDao.getAllVolunteers();
    return all.where((v) => v.groupId == null || v.groupId == 0).toList();
  }

  List<Volunteer> _filterVolunteers(List<Volunteer> volunteers) {
    if (_searchQuery.isEmpty) return volunteers;
    final lowerCaseQuery = _searchQuery.toLowerCase();
    return volunteers.where((volunteer) {
      return volunteer.fullName.toLowerCase().contains(lowerCaseQuery) ||
          volunteer.callSign.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  Future<void> loadVolunteers() async {
    _volunteers = await _volunteersDao.getAllVolunteers();
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

  Future<List<Volunteer>> getAllVolunteers() =>
      _volunteersDao.getAllVolunteers();

  Future<List<Volunteer>> getVolunteersByGroupId(int groupId) =>
      _volunteersDao.getVolunteersByGroupId(groupId);

  Future<List<Volunteer>> getSentVolunteers() =>
      _volunteersDao.getSentVolunteers();

  Future<List<Volunteer>> getNotSentVolunteers() =>
      _volunteersDao.getNotSentVolunteers();

  Future<List<Volunteer>> getAddedToGroupVolunteers() =>
      _volunteersDao.getAddedToGroupVolunteers();

  Future<List<Volunteer>> getVolunteersByStatusAndNotAddedToGroup(
          String status) =>
      _volunteersDao.getVolunteersByStatusAndNotAddedToGroup(status);

  Future<void> insertVolunteer(Volunteer volunteer) async {
    await _volunteersDao.insertVolunteer(volunteer);
    await loadVolunteers();
  }

  Future<void> updateVolunteer(Volunteer volunteer) async {
    await _volunteersDao.updateVolunteer(volunteer);
    await loadVolunteers();
  }

  Future<void> deleteVolunteer(Volunteer volunteer) async {
    await _volunteersDao.deleteVolunteer(volunteer);
    await loadVolunteers();
  }

  Future<void> deleteAllVolunteers() async {
    await _volunteersDao.deleteAllVolunteers();
    await loadVolunteers();
  }

  Future<Volunteer?> getVolunteerById(int id) =>
      _volunteersDao.getVolunteerById(id);

  Future<List<Volunteer>> get activeVolunteers async {
    final volunteers = await _volunteersDao.getAllVolunteers();
    return volunteers.where((v) => v.status == "Active").toList();
  }

  Future<List<Volunteer>> get archivedVolunteers async {
    final volunteers = await _volunteersDao.getAllVolunteers();
    return volunteers.where((v) => v.status == "Archived").toList();
  }

  Future<void> archiveVolunteer(int volunteerId) async {
    final volunteer = await getVolunteerById(volunteerId);
    if (volunteer != null) {
      volunteer.status = "Archived";
      await updateVolunteer(volunteer);
    }
  }

  Future<void> restoreVolunteer(int volunteerId) async {
    final volunteer = await getVolunteerById(volunteerId);
    if (volunteer != null) {
      volunteer.status = "Active";
      await updateVolunteer(volunteer);
    }
  }

  Future<void> deleteVolunteerGlobally(int? uniqueId) async {
    if (uniqueId == null) return;

    try {
      Volunteer? volunteer;

      for (final v in _volunteers) {
        if (v.uniqueId == uniqueId) {
          volunteer = v;
          break;
        }
      }

      if (volunteer != null) {
        if (volunteer.groupId != null) {
          final group = await _groupsDao.getGroupById(volunteer.groupId!);
          if (group != null && group.elderOfGroupId == volunteer.uniqueId) {
            final archivedGroup = group.copyWith(archived: 'true');
            await _groupsDao.updateGroup(archivedGroup);
          }
        }

        await _volunteersDao.deleteVolunteer(volunteer);
      }

      await loadVolunteers();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при глобальном удалении волонтёра: $e');
    }
  }
}
