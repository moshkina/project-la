import 'package:flutter/material.dart';
import '../../data/volunteer.dart';

class VolunteerCard extends StatelessWidget {
  final Volunteer volunteer;
  final VoidCallback? onEdit;
  final VoidCallback? onChangeStatus;
  final VoidCallback? onChangeTime;
  final String? groupName;

  const VolunteerCard({
    Key? key,
    required this.volunteer,
    this.onEdit,
    this.onChangeStatus,
    this.onChangeTime,
    this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF4E4E4E),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopRow(context),
                const SizedBox(height: 8),
                Text('ФИО: ${volunteer.fullName}',style: TextStyle(color: Colors.white),),
                Text('Позывной: ${volunteer.callSign}',style: TextStyle(color: Colors.white)),
                Text('Ник на форуме: ${volunteer.nickName}',style: TextStyle(color: Colors.white)),
                Text('Регион: ${volunteer.region}',style: TextStyle(color: Colors.white)),
                Text('Телефон: ${volunteer.phoneNumber}',style: TextStyle(color: Colors.white)),
                Text('Авто: ${volunteer.car}',style: TextStyle(color: Colors.white)),
                if (groupName != null) Text('Группа: $groupName',style: TextStyle(color: Colors.white)),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: PopupMenuButton<String>(
                icon:Icon(Icons.arrow_drop_down_outlined, color:Colors.white),
                color:Colors.black,
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
                  const PopupMenuItem(value: 'status', child: Text('Изменить статус',style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(value: 'time', child: Text('Изменить время',style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(value: 'edit', child: Text('Редактировать',style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        Chip(
          label: Text(
            volunteer.status,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: volunteer.status == 'Активный' ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 12),
        Text(
          volunteer.timeForSearch,
          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ],
    );
  }
}
