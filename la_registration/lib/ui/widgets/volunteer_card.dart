import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/volunteer.dart';
import '../../viewmodels/groups_and_volunteers_viewmodel.dart';

class VolunteerCard extends StatelessWidget {
  final Volunteer volunteer;
  final VoidCallback? onEdit;
  final VoidCallback? onChangeStatus;
  final VoidCallback? onChangeTime;
  final VoidCallback? onRemoveFromGroup;
  final String? groupName;
  final bool isInGroupContext;

  const VolunteerCard({
    Key? key,
    required this.volunteer,
    this.onEdit,
    this.onChangeStatus,
    this.onChangeTime,
    this.onRemoveFromGroup,
    this.groupName,
    this.isInGroupContext = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4E4E4E),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildTopRow(),
                Positioned(
                  top: 0,
                  right: 0,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: Colors.black,
                    onSelected: (value) {
                      switch (value) {
                        case 'status':
                          onChangeStatus?.call();
                          break;
                        case 'time':
                          onChangeTime?.call();
                          break;
                        case 'edit':
                          onEdit?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'status',
                        child: Text('Изменить статус',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: 'time',
                        child: Text('Изменить время',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Редактировать',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('ФИО: ${volunteer.fullName}',
                style: const TextStyle(color: Colors.white)),
            if (volunteer.callSign.isNotEmpty)
              Text('Позывной: ${volunteer.callSign}',
                  style: const TextStyle(color: Colors.white)),
            if (volunteer.nickName.isNotEmpty)
              Text('Ник на форуме: ${volunteer.nickName}',
                  style: const TextStyle(color: Colors.white)),
            if (volunteer.region.isNotEmpty)
              Text('Регион: ${volunteer.region}',
                  style: const TextStyle(color: Colors.white)),
            Text('Телефон: ${volunteer.phoneNumber}',
                style: const TextStyle(color: Colors.white)),
            if (volunteer.car.isNotEmpty)
              Text('Авто: ${volunteer.car}',
                  style: const TextStyle(color: Colors.white)),
            if (volunteer.additionalInfo.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text('Дополнительно:',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(volunteer.additionalInfo,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            if (groupName != null)
              Text('Группа: $groupName',
                  style: const TextStyle(color: Colors.white)),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: isInGroupContext
                    ? 'Удалить из группы'
                    : 'Удалить глобально',
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[900],
                      title: const Text('Подтверждение',
                          style: TextStyle(color: Colors.white)),
                      content: Text(
                          isInGroupContext
                              ? 'Вы уверены, что хотите удалить ${volunteer.fullName} из группы?'
                              : 'Вы уверены, что хотите удалить ${volunteer.fullName} полностью?',
                          style: const TextStyle(color: Colors.white70)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Отмена',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Да',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final volunteersViewModel =
                        context.read<VolunteersViewModel>();

                    if (isInGroupContext && onRemoveFromGroup != null) {
                      await volunteersViewModel
                          .updateVolunteer(volunteer.copyWith(groupId: null));
                      onRemoveFromGroup!.call();
                    } else {
                      await volunteersViewModel
                          .deleteVolunteerGlobally(volunteer.uniqueId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('${volunteer.fullName} удалён глобально')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        Chip(
          label: Text(volunteer.status,
              style: const TextStyle(color: Colors.white)),
          backgroundColor:
              volunteer.status == 'Активный' ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 12),
        Text(volunteer.timeForSearch,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
