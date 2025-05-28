import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import 'package:la_registration/data/group_callsign.dart'; // Ensure GroupCallsign is imported correctly

class AddNewGroupScreen extends StatefulWidget {
  final GroupCallsigns
      groupCallsign; // Use GroupCallsigns, which is the enum type
  final bool isGroupEdit;
  final int groupId;

  const AddNewGroupScreen({
    super.key,
    required this.groupCallsign,
    required this.isGroupEdit,
    required this.groupId,
  });

  @override
  AddNewGroupScreenState createState() => AddNewGroupScreenState();
}

class AddNewGroupScreenState extends State<AddNewGroupScreen> {
  late TextEditingController elderController;
  late TextEditingController searcherController;
  List<Volunteer> searchersList = [];
  Volunteer? elder;

  @override
  void initState() {
    super.initState();

    elderController = TextEditingController();
    searcherController = TextEditingController();

    if (widget.isGroupEdit) {
      _loadGroupData();
    }
  }

  Future<void> _loadGroupData() async {
    final groupsViewModel = context.read<GroupsViewModel>();
    final volunteersViewModel = context.read<VolunteersViewModel>();

    try {
      // Получаем группу, ожидая результат Future
      final group = await groupsViewModel.getGroupById(widget.groupId);

      // Проверяем, если группа существует, то ищем старшего
      if (group != null) {
        final elderVol =
            await volunteersViewModel.getVolunteerById(group.elderOfGroupId);

        setState(() {
          elder = elderVol;
          // Проверяем, если elderVol не равен null
          elderController.text = elderVol?.fullName ?? '';
        });
      } else {
        // Обработка случая, когда группа не найдена
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Группа не найдена")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка загрузки данных группы")),
        );
      }
    }
  }

  void _saveGroup() {
    if (elder == null || searchersList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Выберите старшего и хотя бы одного поисковика."),
        ),
      );
      return;
    }

    final groupsViewModel = context.read<GroupsViewModel>();

    final group = Group(
      id: widget.isGroupEdit ? widget.groupId : 0,
      numberOfGroup: 1, // Assuming this value
      dateOfCreation:
          DateTime.now().toIso8601String(), // Convert DateTime to String
      groupCallsign: widget.groupCallsign, // Use groupCallsign enum
      elderOfGroupId: elder!.uniqueId ?? 0, // Ensure elder is not null
      // searchers: searchersList, // Ensure searchers are correctly passed
      archived: 'false', // Default archived status
    );

    if (widget.isGroupEdit) {
      groupsViewModel.updateGroup(group);
    } else {
      groupsViewModel.insertGroup(group);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить группу',
            style: TextStyle(
                color: Colors.white)), // Белый текст на оранжевом фоне
        backgroundColor: const Color(0xFFF96800), // Оранжевый фон для заголовка
      ),
      backgroundColor: Colors.black, // Чёрный фон для всего экрана
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: elderController,
              decoration: const InputDecoration(
                labelText: "Старший",
                labelStyle:
                    TextStyle(color: Colors.white), // Белый цвет для текста
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // Белая линия под текстом
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searcherController,
              decoration: const InputDecoration(
                labelText: "Поисковик",
                labelStyle:
                    TextStyle(color: Colors.white), // Белый цвет для текста
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // Белая линия под текстом
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF96800), // Оранжевая кнопка
              ),
              child: const Text(
                'Сохранить группу',
                style: TextStyle(color: Colors.white), // Белый текст на кнопке
              ),
            ),
          ],
        ),
      ),
    );
  }
}
