import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/volunteer.dart';
import '../../data/group.dart'; // Импорт класса Group
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: FutureBuilder<Group?>(
        future: groupsViewModel.getGroupById(groupId), // Получаем группу
        builder: (context, groupSnapshot) {
          if (groupSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (groupSnapshot.hasError) {
            return Center(child: Text('Error: ${groupSnapshot.error}'));
          } else if (!groupSnapshot.hasData || groupSnapshot.data == null) {
            return const Center(child: Text('Group not found.'));
          }

          final group =
              groupSnapshot.data!; // Теперь group - это Group, а не Future

          return FutureBuilder<List<Volunteer>>(
            future: volunteersViewModel.getVolunteersByGroupId(groupId),
            builder: (context, volunteersSnapshot) {
              if (volunteersSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (volunteersSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${volunteersSnapshot.error}'));
              } else if (!volunteersSnapshot.hasData ||
                  volunteersSnapshot.data!.isEmpty) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('Group #${group.numberOfGroup}'),
                      subtitle: Text(group.dateOfCreation.toString()),
                    ),
                    const Center(child: Text('No volunteers found.')),
                  ],
                );
              }

              final volunteers = volunteersSnapshot.data!;

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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Навигация на экран редактирования или сохранения группы
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
