import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/group.dart';
import '../../viewmodels/groups_and_volunteers_viewmodel.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isArchived;

  const GroupCard({super.key, required this.group, required this.isArchived});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title: Text(
          '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Задача: ${group.navigators}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
          color: Colors.black,
          onSelected: (value) async {
            if (value == 'archive' && !isArchived) {
              final updatedGroup = group.copyWith(archived: 'true');
              await context.read<GroupsViewModel>().updateGroup(updatedGroup);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Группа отправлена в архив')),
              );
           } else if (value == 'details') {
              Navigator.pushNamed(
                context, 
                '/group_details',
                arguments: {
                  'groupId': group.id,
                  'isGroupArchive': isArchived,
                },
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'details',
              child: Text('Подробнее', style: TextStyle(color: Colors.white)),
            ),
            if (!isArchived)
              const PopupMenuItem(
                value: 'archive',
                child: Text('Отправить в архив',
                    style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
