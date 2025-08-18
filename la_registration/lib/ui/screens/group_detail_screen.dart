import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/volunteer.dart';
import '../../data/group.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import '../widgets/volunteer_card.dart';

class GroupDetailScreen extends StatefulWidget {
  final int groupId;
  final bool isGroupArchive;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
    required this.isGroupArchive,
  });


  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late TextEditingController _taskController;
  late TextEditingController _navigatorsController;
  late TextEditingController _radiosController;
  late TextEditingController _compassesController;
  late TextEditingController _flashlightsController;
  late TextEditingController _otherEquipmentController;
  late Future<Group?> _groupFuture;
  Group? _currentGroup; // Добавляем переменную для хранения текущей группы

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _navigatorsController = TextEditingController();
    _radiosController = TextEditingController();
    _compassesController = TextEditingController();
    _flashlightsController = TextEditingController();
    _otherEquipmentController = TextEditingController();
    _loadGroupData();
  }

  void _loadGroupData() {
    _groupFuture = context.read<GroupsViewModel>().getGroupById(widget.groupId)
      ..then((group) {
        if (mounted && group != null) {
          setState(() {
            _currentGroup = group;
            _initializeControllers(group);
          });
        }
      });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _navigatorsController.dispose();
    _radiosController.dispose();
    _compassesController.dispose();
    _flashlightsController.dispose();
    _otherEquipmentController.dispose();
    super.dispose();
  }


   @override
  Widget build(BuildContext context) {
    final volunteersViewModel = context.watch<VolunteersViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Детали группы', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFF96800),
      ),
      body: FutureBuilder<Group?>(
        future: _groupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Группа не найдена', style: TextStyle(color: Colors.white)));
          }

          return FutureBuilder<List<Volunteer>>(
            future: volunteersViewModel.getVolunteersByGroupId(widget.groupId),
            builder: (context, volunteersSnapshot) {
              if (volunteersSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (volunteersSnapshot.hasError) {
                return Center(child: Text('Ошибка: ${volunteersSnapshot.error}', style: const TextStyle(color: Colors.white)));
              }

              final volunteers = volunteersSnapshot.data ?? [];
              Volunteer? elder;
              
              elder = volunteers.firstWhere(
                  (v) => v.uniqueId == _currentGroup?.elderOfGroupId,
                );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupHeader(_currentGroup!),
                    const SizedBox(height: 20),
                    if (elder != null) _buildElderCard(elder),
                    const SizedBox(height: 20),
                    _buildTaskSection(),
                    const SizedBox(height: 20),
                    _buildEquipmentSection(),
                    const SizedBox(height: 20),
                    _buildMembersSection(
                      volunteers.where((v) => elder == null || v.uniqueId != elder.uniqueId).toList()
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _currentGroup != null 
            ? () => _saveGroup(context, _currentGroup!)
            : null,
        backgroundColor: const Color(0xFFF96800),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }


  void _addMember() async {
  final volunteersViewModel = context.read<VolunteersViewModel>();
  final availableVolunteers = await volunteersViewModel.getVolunteersWithoutGroup();

  if (!mounted) return;

  final selectedVolunteer = await showDialog<Volunteer>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Добавить участника', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: availableVolunteers.length,
          itemBuilder: (context, index) {
            final volunteer = availableVolunteers[index];
            return ListTile(
              title: Text(volunteer.fullName, style: const TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, volunteer),
            );
          },
        ),
      ),
    ),
  );

  if (selectedVolunteer != null) {
    await volunteersViewModel.updateVolunteer(
      selectedVolunteer.copyWith(groupId: widget.groupId),
    );
    if (mounted) setState(() {});
  }
}

void _editMember(Volunteer volunteer) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text('Редактировать ${volunteer.fullName}', style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Удалить из группы', style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.delete, color: Colors.red),
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ),
  );

  if (result == true) {
    final volunteersViewModel = context.read<VolunteersViewModel>();
    await volunteersViewModel.updateVolunteer(
      volunteer.copyWith(groupId: null),
    );
    if (mounted) setState(() {});
  }
}

  void _initializeControllers(Group group) {
    _taskController.text = group.task ?? '';
    _navigatorsController.text = group.navigators;
    _radiosController.text = group.radios ?? '';
    _compassesController.text = group.compasses ?? '';
    _flashlightsController.text = group.flashlights ?? '';
    _otherEquipmentController.text = group.otherEquipment ?? '';
  }

  Widget _buildGroupHeader(Group group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${group.groupCallsign.toString().split('.').last} №${group.numberOfGroup}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Создана: ${group.dateOfCreation}',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildElderCard(Volunteer elder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Старший группы:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        VolunteerCard(
          volunteer: elder,
          groupName: 'Старший',
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Задача группы:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _taskController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Введите задачу группы...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Оборудование группы:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        _buildEquipmentField('Навигаторы:', _navigatorsController),
        const SizedBox(height: 8),
        _buildEquipmentField('Рации:', _radiosController),
        const SizedBox(height: 8),
        _buildEquipmentField('Компасы:', _compassesController),
        const SizedBox(height: 8),
        _buildEquipmentField('Фонари:', _flashlightsController),
        const SizedBox(height: 8),
        _buildEquipmentField('Другое оборудование:', _otherEquipmentController),
      ],
    );
  }

  Widget _buildEquipmentField(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.grey[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection(List<Volunteer> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Участники группы:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (members.isEmpty)
          const Text(
            'Нет участников',
            style: TextStyle(color: Colors.white70),
          )
        else
          SizedBox(
            height: 300, // Фиксированная высота для прокрутки
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: VolunteerCard(
                    volunteer: members[index],
                    onEdit: () => _editMember(members[index]),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addMember,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF96800),
          ),
          child: const Text(
            'Добавить участника',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _saveGroup(BuildContext context, Group group) async {
    final updatedGroup = group.copyWith(
      task: _taskController.text,
      navigators: _navigatorsController.text,
      radios: _radiosController.text,
      compasses: _compassesController.text,
      flashlights: _flashlightsController.text,
      otherEquipment: _otherEquipmentController.text,
    );

    try {
      await context.read<GroupsViewModel>().updateGroup(updatedGroup);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Группа успешно обновлена')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при сохранении: $e')),
        );
      }
    }
  }
}