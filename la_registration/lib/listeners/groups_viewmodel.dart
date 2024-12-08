import 'package:flutter/material.dart';
import '../data/group.dart';

class GroupsViewModel extends ChangeNotifier {
  final List<Group> _groups = [];
  List<Group> get groups => _groups; // Геттер для доступа к списку групп

  Group getGroupById(int id) {
    return _groups.firstWhere(
      (group) => group.id == id,
      orElse: () => throw Exception("Group not found"),
    );
  }

  void insertGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void updateGroup(Group group) {
    int index = _groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      _groups[index] = group;
      notifyListeners();
    }
  }

  // Метод для получения активных групп
  Future<List<Group>> getActiveGroups(String groupCallsign) async {
    await Future.delayed(
        const Duration(milliseconds: 200)); // Симуляция задержки
    return _groups
        .where((group) => group.groupCallsign.name == groupCallsign)
        .toList();
  }

  // Новый метод для получения архивных групп
  Future<List<Group>> getArchivedGroups(String groupCallsign) async {
    await Future.delayed(
        const Duration(milliseconds: 200)); // Симуляция задержки
    return _groups
        .where((group) =>
            group.groupCallsign.name == groupCallsign &&
            group.task.isEmpty) // Условие для архивных групп
        .toList();
  }
}
