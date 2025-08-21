import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import '../widgets/group_card.dart'; // Импортируем GroupCard

class ArchiveGroupsScreen extends StatefulWidget {
  final GroupCallsigns groupCallsign;

  const ArchiveGroupsScreen({super.key, required this.groupCallsign});

  @override
  State<ArchiveGroupsScreen> createState() => _ArchiveGroupsScreenState();
}

class _ArchiveGroupsScreenState extends State<ArchiveGroupsScreen> {
  late Future<List<Group>> _futureGroups;

  @override
  void initState() {
    super.initState();
    _loadArchivedGroups();
  }

  void _loadArchivedGroups() {
    _futureGroups = Provider.of<GroupsViewModel>(context, listen: false)
        .getGroupByCallsignArchived(widget.groupCallsign.name);
  }

  Future<Volunteer?> _getElderForGroup(Group group) async {
    try {
      final volunteersViewModel = context.read<VolunteersViewModel>();
      return await volunteersViewModel.getVolunteerById(group.elderOfGroupId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _clearArchive() async {
    final viewModel = Provider.of<GroupsViewModel>(context, listen: false);
    await viewModel.deleteArchivedGroups();
    _loadArchivedGroups();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Group>>(
        future: _futureGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final groups = snapshot.data ?? [];

          if (groups.isEmpty) {
            return const Center(
              child: Text(
                'Нет архивных групп',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return FutureBuilder<Volunteer?>(
                future: _getElderForGroup(group),
                builder: (context, elderSnapshot) {
                  return GroupCard(
                    group: group,
                    isArchived: true, // Важно: передаем true для архивных групп
                    elder: elderSnapshot.data,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF96800),
        child: const Icon(Icons.delete_forever, color: Colors.white),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text('Очистить архив?', style: TextStyle(color: Colors.white)),
              content: const Text('Все архивные группы будут удалены безвозвратно.', style: TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Отмена', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await _clearArchive();
          }
        },
      ),
    );
  }
}