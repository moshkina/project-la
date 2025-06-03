import 'package:flutter/material.dart';
import '../../data/group.dart';

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
          icon:Icon(Icons.arrow_drop_down_outlined, color:Colors.white),
          color:Colors.black,
          onSelected: (value) {
            if (value == 'archive' && !isArchived) {
              // Логика архивации
            } else if (value == 'details') {
              Navigator.pushNamed(context, '/group_details',
                  arguments: group.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'details', child: Text('View Details',style: TextStyle(color: Colors.white))),
            if (!isArchived)
              const PopupMenuItem(value: 'archive', child: Text('Archive',style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
