import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/group.dart';
import '../../data/volunteer.dart';
import '../../viewmodels/groups_and_volunteers_viewmodel.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isArchived;
  final Volunteer? elder;

  const GroupCard({
    super.key,
    required this.group,
    required this.isArchived,
    this.elder,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, groupsViewModel, child) {
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          color: Colors.white, size: 20),
                      color: Colors.black,
                      onSelected: (value) async {
                        if (value == 'archive' && !isArchived) {
                          final updatedGroup = group.copyWith(archived: 'true');
                          await groupsViewModel.updateGroup(updatedGroup);
                          // ViewModel автоматически уведомит всех Consumer'ов
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Группа отправлена в архив')),
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
                          child: Text('Подробнее',
                              style: TextStyle(color: Colors.white)),
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
                if (elder != null && elder!.fullName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Старший: ${elder!.fullName}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Задача группы
                if (group.task != null && group.task!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Задача: ${group.task}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Заметка (только если есть)
                if (group.notes != null && group.notes!.isNotEmpty)
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
                if (_hasEquipment())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      _getEquipmentSummary(),
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Отладочная информация о состоянии
                if (group.archived == 'true')
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'АРХИВ',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Проверяем есть ли оборудование
  bool _hasEquipment() {
    return group.navigators.isNotEmpty ||
        (group.radios != null && group.radios!.isNotEmpty) ||
        (group.compasses != null && group.compasses!.isNotEmpty) ||
        (group.flashlights != null && group.flashlights!.isNotEmpty) ||
        (group.otherEquipment != null && group.otherEquipment!.isNotEmpty);
  }

  // Вспомогательный метод для краткого отображения оборудования
  String _getEquipmentSummary() {
    final equipment = [];

    if (group.navigators.isNotEmpty) {
      equipment.add('Навигаторы: ${group.navigators}');
    }
    if (group.radios != null && group.radios!.isNotEmpty) {
      equipment.add('Рации: ${group.radios}');
    }
    if (group.compasses != null && group.compasses!.isNotEmpty) {
      equipment.add('Компасы: ${group.compasses}');
    }
    if (group.flashlights != null && group.flashlights!.isNotEmpty) {
      equipment.add('Фонари: ${group.flashlights}');
    }
    if (group.otherEquipment != null && group.otherEquipment!.isNotEmpty) {
      equipment.add('Прочее: ${group.otherEquipment}');
    }

    return equipment.isNotEmpty ? 'Оборудование: ${equipment.join(", ")}' : '';
  }
}
