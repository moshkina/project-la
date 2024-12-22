import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/group.dart';
import 'package:la_registration/listeners/groups_viewmodel.dart';
import '../widgets/group_card.dart';

class ArchiveGroupsScreen extends StatelessWidget {
  final String groupCallsign;

  const ArchiveGroupsScreen({super.key, required this.groupCallsign});

  @override
  Widget build(BuildContext context) {
    final groupsViewModel = context.watch<GroupsViewModel>();

    return Scaffold(
      backgroundColor: Colors.black, // Чёрный фон для страницы
      body: FutureBuilder<List<Group>>(
        future: groupsViewModel.getArchivedGroups(groupCallsign),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final groups = snapshot.data ?? [];
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return GroupCard(group: groups[index], isArchived: true);
            },
          );
        },
      ),
    );
  }
}

