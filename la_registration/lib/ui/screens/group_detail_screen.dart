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
  late TextEditingController _notesController;

  late Future<Group?> _groupFuture;
  Group? _currentGroup;
  List<Volunteer> _volunteers = [];
  Volunteer? _elder;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _navigatorsController = TextEditingController();
    _radiosController = TextEditingController();
    _compassesController = TextEditingController();
    _flashlightsController = TextEditingController();
    _otherEquipmentController = TextEditingController();
    _notesController = TextEditingController();

    _loadGroupData();
    _loadVolunteers();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _navigatorsController.dispose();
    _radiosController.dispose();
    _compassesController.dispose();
    _flashlightsController.dispose();
    _otherEquipmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}.'
          '${date.month.toString().padLeft(2, '0')}.'
          '${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  void _loadGroupData() {
    _groupFuture = context.read<GroupsViewModel>().getGroupById(widget.groupId)
      ..then((group) {
        if (!mounted) return;
        if (group != null) {
          setState(() {
            _currentGroup = group;
            _initializeControllers(group);
          });
          _loadVolunteers();
        }
      });
  }

  Future<void> _loadVolunteers() async {
    try {
      final volunteersViewModel = context.read<VolunteersViewModel>();
      final volunteers =
          await volunteersViewModel.getVolunteersByGroupId(widget.groupId);

      if (!mounted) return;

      Volunteer? elder;
      elder = volunteers
          .where((v) => v.uniqueId == _currentGroup!.elderOfGroupId)
          .toList()
          .cast<Volunteer?>()
          .firstOrNull;

      setState(() {
        _volunteers = volunteers;
        _elder = elder;
      });
    } catch (e) {
      debugPrint('Error loading volunteers: $e');
    }
  }

  void _initializeControllers(Group group) {
    _taskController.text = group.task ?? '';
    _navigatorsController.text = group.navigators;
    _radiosController.text = group.radios ?? '';
    _compassesController.text = group.compasses ?? '';
    _flashlightsController.text = group.flashlights ?? '';
    _otherEquipmentController.text = group.otherEquipment ?? '';
    _notesController.text = group.notes ?? '';
  }

  Future<void> _addMember() async {
    final volunteersViewModel = context.read<VolunteersViewModel>();
    final availableVolunteers =
        await volunteersViewModel.getVolunteersWithoutGroup();

    if (!mounted) return;

    final selectedVolunteer = await showDialog<Volunteer>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Добавить участника',
            style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableVolunteers.length,
            itemBuilder: (context, index) {
              final volunteer = availableVolunteers[index];
              return ListTile(
                title: Text(volunteer.fullName,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(volunteer.callSign,
                    style: const TextStyle(color: Colors.white70)),
                onTap: () => Navigator.pop(context, volunteer),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (selectedVolunteer != null) {
      await volunteersViewModel
          .updateVolunteer(selectedVolunteer.copyWith(groupId: widget.groupId));
      await _loadVolunteers();
    }
  }

  Future<void> _saveGroup(BuildContext context, Group group) async {
    final updatedGroup = group.copyWith(
      task: _taskController.text,
      navigators: _navigatorsController.text,
      radios: _radiosController.text,
      compasses: _compassesController.text,
      flashlights: _flashlightsController.text,
      otherEquipment: _otherEquipmentController.text,
      notes: _notesController.text,
    );

    try {
      await context.read<GroupsViewModel>().updateGroup(updatedGroup);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Группа успешно обновлена')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    }
  }

  Widget _buildGroupHeader(Group group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${group.groupCallsign.getGroupCallsignAsString().split('.').last} №${group.numberOfGroup}',
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text('Создана: ${_formatDateTime(group.dateOfCreation)}',
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildElderCard(Volunteer elder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Старший группы:',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        VolunteerCard(
          volunteer: elder,
          groupName: 'Старший',
          isInGroupContext: true,
          onRemoveFromGroup: _loadVolunteers,
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Задача группы:',
            style: TextStyle(color: Colors.white, fontSize: 18)),
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
                borderSide: const BorderSide(color: Colors.white)),
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
        const Text('Оборудование группы:',
            style: TextStyle(color: Colors.white, fontSize: 18)),
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
            child: Text(label, style: const TextStyle(color: Colors.white70))),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white)),
              filled: true,
              fillColor: Colors.grey[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Заметки о группе:',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Дополнительная информация о группе...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white)),
            filled: true,
            fillColor: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection(List<Volunteer> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Участники группы:',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        if (members.isEmpty)
          const Text('Нет участников', style: TextStyle(color: Colors.white70))
        else
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: VolunteerCard(
                    volunteer: member,
                    isInGroupContext: true,
                    onRemoveFromGroup: _loadVolunteers,
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addMember,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF96800)),
          child: const Text('Добавить участника',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text('Детали группы', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFF96800),
      ),
      body: FutureBuilder<Group?>(
        future: _groupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Ошибка: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text('Группа не найдена',
                    style: TextStyle(color: Colors.white)));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGroupHeader(_currentGroup!),
                const SizedBox(height: 20),
                if (_elder != null) _buildElderCard(_elder!),
                const SizedBox(height: 20),
                _buildTaskSection(),
                const SizedBox(height: 20),
                _buildEquipmentSection(),
                const SizedBox(height: 20),
                _buildNotesSection(),
                const SizedBox(height: 20),
                _buildMembersSection(_volunteers
                    .where(
                        (v) => _elder == null || v.uniqueId != _elder!.uniqueId)
                    .toList()),
              ],
            ),
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
}
