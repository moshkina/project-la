import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/group.dart';
import 'package:la_registration/listeners/groups_viewmodel.dart';
import '../widgets/group_card.dart';

class ActiveGroupsScreen extends StatelessWidget {
  final String groupCallsign;

  const ActiveGroupsScreen({super.key, required this.groupCallsign});

  @override
  Widget build(BuildContext context) {
    final groupsViewModel = context.watch<GroupsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Groups ($groupCallsign)'),
      ),
      body: FutureBuilder<List<Group>>(
        future: groupsViewModel.getActiveGroups(groupCallsign),
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
              return GroupCard(group: groups[index], isArchived: false);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_group', arguments: groupCallsign);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
