import 'package:flutter/foundation.dart';
import '../data/group.dart';
import '../data/groups_dao.dart';
import '../data/group_callsign.dart';

class GroupsViewModel extends ChangeNotifier {
  final GroupsDao _groupsDao;

  GroupsViewModel(this._groupsDao);

  Future<List<Group>> getAllGroups() => _groupsDao.getAllGroups();

  Future<List<Group>> getGroupByCallsignNotArchived(String groupCallsign) {
    final callsign = GroupCallsigns.fromString(groupCallsign);
    if (callsign == null) {
      throw ArgumentError('Invalid groupCallsign: $groupCallsign');
    }
    return _groupsDao.getGroupsByCallsignNotArchived(callsign);
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

  Future<void> insertGroup(Group group) async {
    await _groupsDao.insertGroup(group);
    notifyListeners();
  }

  Future<void> updateGroup(Group group) async {
    await _groupsDao.updateGroup(group);
    notifyListeners();
  }

  Future<void> deleteGroup(Group group) async {
    await _groupsDao.deleteGroup(group);
    notifyListeners();
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
