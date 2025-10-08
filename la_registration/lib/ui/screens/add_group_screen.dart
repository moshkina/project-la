import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import 'package:la_registration/data/group_callsign.dart';

class AddNewGroupScreen extends StatefulWidget {
  final GroupCallsigns groupCallsign;
  final bool isGroupEdit;
  final int groupId;

  const AddNewGroupScreen({
    super.key,
    required this.groupCallsign,
    required this.isGroupEdit,
    required this.groupId,
  });

  @override
  AddNewGroupScreenState createState() => AddNewGroupScreenState();
}

class AddNewGroupScreenState extends State<AddNewGroupScreen> {
  late TextEditingController elderController;
  late TextEditingController searcherController;
  List<Volunteer> searchersList = [];
  Volunteer? elder;
  Map<int, GroupInfo> volunteerGroupInfoCache = {};
  List<Volunteer> _allActiveVolunteers = [];

  @override
  void initState() {
    super.initState();

    elderController = TextEditingController();
    searcherController = TextEditingController();

    if (widget.isGroupEdit) {
      _loadGroupData();
    }
    _loadVolunteersData();
  }

  Future<void> _loadVolunteersData() async {
    final volunteersViewModel = context.read<VolunteersViewModel>();
    final groupsViewModel = context.read<GroupsViewModel>();

    final volunteers = await volunteersViewModel.getAllVolunteers();
    final activeVolunteers =
        volunteers.where((v) => v.status == "Активный").toList();

    for (final volunteer in activeVolunteers) {
      if (volunteer.groupId != null &&
          !volunteerGroupInfoCache.containsKey(volunteer.groupId)) {
        final group = await groupsViewModel.getGroupById(volunteer.groupId!);
        if (group == null) {
          volunteerGroupInfoCache[volunteer.groupId!] =
              GroupInfo(type: GroupType.deleted, group: null);
        } else if (group.archived == 'true') {
          volunteerGroupInfoCache[volunteer.groupId!] =
              GroupInfo(type: GroupType.archived, group: group);
        } else {
          volunteerGroupInfoCache[volunteer.groupId!] =
              GroupInfo(type: GroupType.active, group: group);
        }
      }
    }

    setState(() {
      _allActiveVolunteers = activeVolunteers;
    });
  }

  Future<void> _loadGroupData() async {
    final groupsViewModel = context.read<GroupsViewModel>();
    final volunteersViewModel = context.read<VolunteersViewModel>();

    try {
      final group = await groupsViewModel.getGroupById(widget.groupId);

      if (group != null) {
        final elderVol =
            await volunteersViewModel.getVolunteerById(group.elderOfGroupId);

        setState(() {
          elder = elderVol;
          elderController.text = elderVol?.fullName ?? '';
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Группа не найдена")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка загрузки данных группы")),
        );
      }
    }
  }

  GroupInfo _getVolunteerGroupInfo(Volunteer volunteer) {
    if (volunteer.groupId == null) {
      return GroupInfo(type: GroupType.none, group: null);
    }

    return volunteerGroupInfoCache[volunteer.groupId!] ??
        GroupInfo(type: GroupType.deleted, group: null);
  }

  Color _getVolunteerTextColor(GroupType groupType) {
    switch (groupType) {
      case GroupType.none:
        return Colors.white;
      case GroupType.archived:
        return Colors.orange;
      case GroupType.deleted:
        return Colors.grey;
      case GroupType.active:
        return Colors.red;
    }
  }

  String _getGroupStatusText(GroupInfo groupInfo) {
    switch (groupInfo.type) {
      case GroupType.none:
        return '';
      case GroupType.archived:
        final group = groupInfo.group!;
        return ' (архив: ${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup})';
      case GroupType.deleted:
        return ' (группа удалена)';
      case GroupType.active:
        final group = groupInfo.group!;
        return ' (активна: ${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup})';
    }
  }

  bool _canAddVolunteer(GroupType groupType) {
    return groupType == GroupType.none ||
        groupType == GroupType.archived ||
        groupType == GroupType.deleted;
  }

  Iterable<Volunteer> _getAvailableVolunteers(String searchText) {
    final lowerText = searchText.toLowerCase();
    return _allActiveVolunteers.where((volunteer) {
      final matchesName = volunteer.fullName.toLowerCase().contains(lowerText);
      final groupInfo = _getVolunteerGroupInfo(volunteer);
      return matchesName && _canAddVolunteer(groupInfo.type);
    });
  }

  String _getDisplayString(Volunteer volunteer) {
    final groupInfo = _getVolunteerGroupInfo(volunteer);
    return volunteer.fullName + _getGroupStatusText(groupInfo);
  }

  void _saveGroup() async {
    if (elder == null || searchersList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Выберите старшего и хотя бы одного поисковика."),
        ),
      );
      return;
    }

    if (!searchersList.contains(elder)) {
      searchersList.add(elder!);
    }

    final groupsViewModel = context.read<GroupsViewModel>();
    final volunteersViewModel = context.read<VolunteersViewModel>();
    final lastNumber =
        await groupsViewModel.getLastNumberOfGroup(widget.groupCallsign.name);
    final newGroupNumber = (lastNumber ?? 0) + 1;

    final group = Group(
      id: widget.isGroupEdit ? widget.groupId : null,
      numberOfGroup: newGroupNumber,
      dateOfCreation: DateTime.now().toIso8601String(),
      groupCallsign: widget.groupCallsign,
      elderOfGroupId: elder!.uniqueId!,
      archived: 'false',
    );

    try {
      int? groupId;
      if (widget.isGroupEdit) {
        await groupsViewModel.updateGroup(group);
        groupId = group.id;
      } else {
        groupId = await groupsViewModel.insertGroup(group);
      }

      for (final volunteer in searchersList) {
        final updatedVolunteer = volunteer.copyWith(groupId: groupId);
        await volunteersViewModel.updateVolunteer(updatedVolunteer);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ошибка: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isGroupEdit ? 'Редактировать группу' : 'Добавить группу',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFF96800),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Старший группы",
                style: TextStyle(color: Colors.white70)),
            Autocomplete<Volunteer>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Volunteer>.empty();
                }
                return _getAvailableVolunteers(textEditingValue.text);
              },
              displayStringForOption: _getDisplayString,
              onSelected: (Volunteer selection) {
                final groupInfo = _getVolunteerGroupInfo(selection);
                if (!_canAddVolunteer(groupInfo.type)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Нельзя выбрать ${selection.fullName} - состоит в активной группе'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() {
                  elder = selection;
                  elderController.text = selection.fullName;
                  if (!searchersList.contains(selection)) {
                    searchersList.add(selection);
                  }
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                elderController = controller;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Введите имя старшего',
                    hintStyle: TextStyle(color: Colors.white54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Добавить поисковика",
                style: TextStyle(color: Colors.white70)),
            Autocomplete<Volunteer>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Volunteer>.empty();
                }
                return _getAvailableVolunteers(textEditingValue.text);
              },
              displayStringForOption: _getDisplayString,
              onSelected: (Volunteer selection) {
                final groupInfo = _getVolunteerGroupInfo(selection);
                if (!_canAddVolunteer(groupInfo.type)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Нельзя добавить ${selection.fullName} - состоит в активной группе'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() {
                  if (!searchersList.contains(selection)) {
                    searchersList.add(selection);
                  }
                });
                searcherController.clear();
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                searcherController = controller;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Введите имя поисковика',
                    hintStyle: TextStyle(color: Colors.white54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Поисковики:", style: TextStyle(color: Colors.white)),
            ...searchersList.map((v) {
              final groupInfo = _getVolunteerGroupInfo(v);
              final color = _getVolunteerTextColor(groupInfo.type);

              return ListTile(
                title: Text(
                  v.fullName + _getGroupStatusText(groupInfo),
                  style: TextStyle(color: color),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      if (v == elder) {
                        elder = null;
                        elderController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Старший удалён из участников.')),
                        );
                      }
                      searchersList.remove(v);
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF96800),
              ),
              child: const Text(
                'Сохранить группу',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum GroupType { none, active, archived, deleted }

class GroupInfo {
  final GroupType type;
  final Group? group;

  GroupInfo({required this.type, required this.group});
}
