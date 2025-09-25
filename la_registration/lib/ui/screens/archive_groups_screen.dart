import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import '../widgets/group_card.dart';

class ArchiveGroupsScreen extends StatefulWidget {
  final GroupCallsigns groupCallsign;
  final String searchQuery;

  const ArchiveGroupsScreen({
    super.key,
    required this.groupCallsign,
    this.searchQuery = '',
  });

  @override
  State<ArchiveGroupsScreen> createState() => _ArchiveGroupsScreenState();
}

class _ArchiveGroupsScreenState extends State<ArchiveGroupsScreen> {
  Future<Volunteer?> _getElderForGroup(Group group) async {
    try {
      final volunteersViewModel = context.read<VolunteersViewModel>();
      return await volunteersViewModel.getVolunteerById(group.elderOfGroupId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _clearArchive() async {
    final viewModel = context.read<GroupsViewModel>();
    await viewModel.deleteArchivedGroups();
    // ViewModel автоматически уведомит об изменениях через notifyListeners()
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, groupsViewModel, child) {
        // Фильтруем архивные группы для текущего callsign
        final archivedGroups = groupsViewModel.groups
            .where((group) =>
                group.groupCallsign == widget.groupCallsign &&
                group.archived == 'true')
            .toList();

        return Scaffold(
          backgroundColor: Colors.black,
          body: archivedGroups.isEmpty
              ? const Center(
                  child: Text(
                    'Нет архивных групп',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: archivedGroups.length,
                  itemBuilder: (context, index) {
                    final group = archivedGroups[index];
                    return FutureBuilder<Volunteer?>(
                      future: _getElderForGroup(group),
                      builder: (context, elderSnapshot) {
                        if (elderSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: CircularProgressIndicator(),
                          );
                        }
                        return GroupCard(
                          group: group,
                          isArchived: true,
                          elder: elderSnapshot.data,
                        );
                      },
                    );
                  },
                ),
          floatingActionButton: archivedGroups.isNotEmpty
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFFF96800),
                  child: const Icon(Icons.delete_forever, color: Colors.white),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[900],
                        title: const Text('Очистить архив?',
                            style: TextStyle(color: Colors.white)),
                        content: const Text(
                            'Все архивные группы будут удалены безвозвратно.',
                            style: TextStyle(color: Colors.white70)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Отмена',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Удалить',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _clearArchive();
                    }
                  },
                )
              : null,
        );
      },
    );
  }
}
