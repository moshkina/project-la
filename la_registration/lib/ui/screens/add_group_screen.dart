import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import 'package:la_registration/data/group_callsign.dart'; // Ensure GroupCallsign is imported correctly
import 'package:la_registration/data/groups_dao.dart';

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

 void _saveGroup() async {
  if (elder == null || searchersList.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Выберите старшего и хотя бы одного поисковика."),
      ),
    );
    return;
  }

  // Убедимся, что старший в списке поисковиков
  if (!searchersList.contains(elder)) {
    searchersList.add(elder!);
  }

  final groupsViewModel = context.read<GroupsViewModel>();
  final volunteersViewModel = context.read<VolunteersViewModel>();
  final lastNumber = await groupsViewModel.getLastNumberOfGroup(widget.groupCallsign.name);
  final newGroupNumber = (lastNumber ?? 0) + 1;

  // Создаём или обновляем группу
  final group = Group(
    id: widget.isGroupEdit ? widget.groupId : null,
    numberOfGroup: newGroupNumber,
    dateOfCreation: DateTime.now().toIso8601String(),
    groupCallsign: widget.groupCallsign,
    elderOfGroupId: elder!.uniqueId!,
    archived: 'false',
  );

  try {
    int? groupId;
    if (widget.isGroupEdit) {
      await groupsViewModel.updateGroup(group);
      groupId = group.id;
    } else {
      groupId = await groupsViewModel.insertGroup(group); // получить ID новой группы
    }

    // Устанавливаем groupId для каждого волонтёра и сохраняем
    for (final volunteer in searchersList) {
      final updatedVolunteer = volunteer.copyWith(groupId: groupId);
      await volunteersViewModel.updateVolunteer(updatedVolunteer);
    }

    if (mounted) {Navigator.pop(context);}
  } catch (e, stackTrace) {
  print('Ошибка при сохранении группы: $e');
  print('StackTrace: $stackTrace');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Ошибка: $e"),
    ),
  );
 }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.isGroupEdit ? 'Редактировать группу' : 'Добавить группу',
          style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFFF96800),
    ),
    backgroundColor: Colors.black,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Старший группы", style: TextStyle(color: Colors.white70)),
          Autocomplete<Volunteer>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return const Iterable.empty();
              final viewModel = context.read<VolunteersViewModel>();
              return viewModel.volunteers
                .where((vol) => vol.groupId == null)
                .where((vol) =>
                  vol.fullName.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            displayStringForOption: (Volunteer vol) => vol.fullName,
            onSelected: (Volunteer selection) {
              setState(() {
                elder = selection;
                elderController.text = selection.fullName;
                // Добавить старшего в список участников, если его там нет
                if (!searchersList.contains(selection)) {
                  searchersList.add(selection);
                }
              });
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              elderController = controller;
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Введите имя старшего',
                  hintStyle: TextStyle(color: Colors.white54),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text("Добавить поисковика", style: TextStyle(color: Colors.white70)),
          Autocomplete<Volunteer>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return const Iterable.empty();
              final viewModel = context.read<VolunteersViewModel>();
              return viewModel.volunteers.where((vol) =>
                  vol.fullName.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            displayStringForOption: (Volunteer vol) => vol.fullName,
            onSelected: (Volunteer selection) {
              setState(() {
                if (!searchersList.contains(selection)) {
                  searchersList.add(selection);
                }
              });
              searcherController.clear();
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              searcherController = controller;
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Введите имя поисковика',
                  hintStyle: TextStyle(color: Colors.white54),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text("Поисковики:", style: TextStyle(color: Colors.white)),
          ...searchersList.map((v) => ListTile(
                title: Text(v.fullName, style: const TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                    if (v == elder) {
                      elder = null;
                      elderController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Старший удалён из участников.')),
                      );
                    }
                    searchersList.remove(v);
                  });
                },
                ),
              )),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveGroup,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF96800),
            ),
            child: const Text(
              'Сохранить группу',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

}
