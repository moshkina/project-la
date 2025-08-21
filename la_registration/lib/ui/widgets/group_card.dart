import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/group.dart';
import '../../data/volunteer.dart';
import '../../viewmodels/groups_and_volunteers_viewmodel.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isArchived;
  final Volunteer? elder; // Добавляем параметр для старшего

  const GroupCard({
    super.key, 
    required this.group, 
    required this.isArchived,
    this.elder, // Делаем необязательным
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с названием группы и кнопкой меню
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
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
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Старший группы
            if (elder != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  'Старший: ${elder!.fullName}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            
            // Задача группы
            if (group.task != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  'Задача: ${group.task}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            
            // Заметка (только если есть)
            if (group.notes != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  'Заметка: ${group.notes}',
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            
            // Оборудование (кратко)
            if (group.navigators.isNotEmpty || 
                group.radios?.isNotEmpty == true || 
                group.compasses?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  _getEquipmentSummary(),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Вспомогательный метод для краткого отображения оборудования
  String _getEquipmentSummary() {
    final equipment = [];
    if (group.navigators.isNotEmpty) equipment.add('Навигаторы: ${group.navigators}');
    if (group.radios?.isNotEmpty == true) equipment.add('Рации: ${group.radios}');
    if (group.compasses?.isNotEmpty == true) equipment.add('Компасы: ${group.compasses}');
    
    return equipment.isNotEmpty ? '${equipment.join(", ")}' : '';
  }
}