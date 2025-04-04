import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../listeners/groups_viewmodel.dart';
import '../../listeners/volunteers_viewmodel.dart';
import '../../data/volunteer.dart';

class GroupDetailScreen extends StatelessWidget {
  final int groupId;
  final bool isGroupArchive;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
    required this.isGroupArchive,
  });

  @override
  Widget build(BuildContext context) {
    final groupsViewModel = context.watch<GroupsViewModel>();
    final volunteersViewModel = context.watch<VolunteersViewModel>();

    final group = groupsViewModel.getGroupById(groupId);

    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: FutureBuilder<List<Volunteer>>(
        future: volunteersViewModel.getVolunteersByGroupId(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No volunteers found.'));
          }

          final volunteers = snapshot.data!;

          return Column(
            children: [
              ListTile(
                title: Text('Group #${group.numberOfGroup}'),
                subtitle: Text(group.dateOfCreation.toString()),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: volunteers.length,
                  itemBuilder: (context, index) {
                    return VolunteerItem(volunteer: volunteers[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Навигация на экран редактирования или сохранения группы
          // Или, если это создание новой группы, можно использовать:
          //  groupsViewModel.addGroup(newGroup);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class VolunteerItem extends StatelessWidget {
  final Volunteer volunteer;

  const VolunteerItem({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(volunteer.fullName),
      subtitle: Text(volunteer.phoneNumber),
    );
  }
}
