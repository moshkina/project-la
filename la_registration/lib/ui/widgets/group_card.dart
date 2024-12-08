import 'package:flutter/material.dart';
import '../../data/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isArchived;

  const GroupCard({super.key, required this.group, required this.isArchived});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Group ${group.numberOfGroup}'),
        subtitle: Text('Members: ${group.membersCount}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'archive' && !isArchived) {
              // Логика архивации
            } else if (value == 'details') {
              Navigator.pushNamed(context, '/group_details',
                  arguments: group.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'details', child: Text('View Details')),
            if (!isArchived)
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
          ],
        ),
      ),
    );
  }
}
