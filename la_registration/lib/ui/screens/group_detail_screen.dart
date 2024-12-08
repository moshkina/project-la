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
        future: volunteersViewModel
            .getVolunteersByGroupId(groupId), // Возвращаем список волонтёров
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
                title: Text(
                    'Group #${group.numberOfGroup}'), // Используем numberOfGroup
                subtitle: Text(group.dateOfCreation
                    .toString()), // Преобразуем DateTime в String
              ),
              TextFormField(
                initialValue: group.task, // Прямое использование task
                decoration: const InputDecoration(labelText: "Task"),
                onChanged: (value) {
                  // Заменим final task через groupsViewModel.updateGroup
                  groupsViewModel.updateGroup(
                    group.copyWith(
                        task: value), // Создаем новый объект с обновленным task
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      volunteers.length, // Доступ к длине списка волонтёров
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
