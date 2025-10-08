import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/ui/widgets/volunteer_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/ui/screens/group_tabs_screen.dart';
import 'package:la_registration/ui/screens/barcode_scanner_screen.dart';
import 'package:la_registration/ui/screens/add_manually_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:la_registration/data/group.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class TabbedMainScreen extends StatefulWidget {
  const TabbedMainScreen({super.key});

  @override
  TabbedMainScreenState createState() => TabbedMainScreenState();
}

class TabbedMainScreenState extends State<TabbedMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameSearchController = TextEditingController();
  bool _isSearchActive = false;
  Timer? _searchDebounce;
  String? _searchName; // хранение имени поиска

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSearchName();
    Future.microtask(() {
      Provider.of<VolunteersViewModel>(context, listen: false).loadVolunteers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameSearchController.dispose();
    _tabController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadSearchName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('search_name');
    if (name != null && mounted) {
      setState(() {
        _searchName = name;
      });
    }
  }

  Future<void> _saveSearchName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('search_name', name);
  }

  Future<String?> _pickTime(String initialTime) async {
    TimeOfDay initial = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      if (!mounted) return null;
      return picked.format(context);
    }
    return null;
  }

  Future<bool> sendVolunteersToInfo(String message) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/отчёт_по_волонтёрам.txt');
      await file.writeAsString(message, encoding: utf8);

      final ShareResult result = await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/plain')],
      );

      debugPrint('Результат шеринга: ${result.status}');

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Ошибка при отправке: $e');
      return false;
    }
  }

  Future<void> _saveAndShareData() async {
    try {
      final volunteersViewModel = context.read<VolunteersViewModel>();
      final groupsViewModel = context.read<GroupsViewModel>();

      final volunteers = await volunteersViewModel.getAllVolunteers();
      final groups = groupsViewModel.groups;

      final archivedGroups = groups.where((g) => g.archived == "true").toList();
      final archivedGroupsVolunteers =
          _getArchivedGroupsVolunteers(volunteers, archivedGroups);
      final data = {
        'volunteers': volunteers.map((v) => _volunteerToJson(v)).toList(),
        'groups': groups.map((g) => _groupToJson(g)).toList(),
        'archived_groups_volunteers': archivedGroupsVolunteers,
      };

      final jsonString = jsonEncode(data);

      final fileName = _searchName != null && _searchName!.isNotEmpty
          ? '${_searchName!.replaceAll(RegExp(r'[^a-zA-Z0-9а-яА-Я]'), '_')}.json'
          : 'резервная_копия_данных.json';

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint('Ошибка при сохранении и отправке данных: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getArchivedGroupsVolunteers(
      List<Volunteer> volunteers, List<Group> archivedGroups) {
    final List<Map<String, dynamic>> result = [];

    for (final group in archivedGroups) {
      final groupVolunteers =
          volunteers.where((v) => v.groupId == group.id).toList();

      for (final volunteer in groupVolunteers) {
        result.add({
          'archivedGroupId': group.id.toString(),
          'archivedVolunteerId': volunteer.uniqueId.toString(),
        });
      }
    }

    return result;
  }

  Map<String, dynamic> _volunteerToJson(Volunteer volunteer) {
    return {
      'uniqueId': volunteer.uniqueId.toString(),
      '_index': volunteer.index.toString(),
      'fullName': volunteer.fullName,
      'callSign': volunteer.callSign,
      'nickName': volunteer.nickName,
      'region': volunteer.region,
      'phoneNumber': volunteer.phoneNumber,
      'car': volunteer.car,
      'additionalInfo': volunteer.additionalInfo,
      'isSent': volunteer.isSent.toString(),
      'status': volunteer.status,
      'notifyThatLeft': volunteer.notifyThatLeft,
      'timeForSearch': volunteer.timeForSearch,
      'groupId': volunteer.groupId?.toString() ?? '',
    };
  }

  Map<String, dynamic> _groupToJson(Group group) {
    return {
      'id': group.id?.toString() ?? '',
      'numberOfGroup': group.numberOfGroup.toString(),
      'elderOfGroupId': group.elderOfGroupId.toString(),
      'navigators': group.navigators,
      'walkieTalkies': group.radios ?? '',
      'compasses': group.compasses ?? '',
      'lamps': group.flashlights ?? '',
      'others': group.otherEquipment ?? '',
      'task': group.task ?? '',
      'leavingTime': '',
      'returnTime': '',
      'dateOfCreation': group.dateOfCreation,
      'groupCallsign': group.groupCallsign.name,
      'archived': group.archived,
    };
  }

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      Provider.of<VolunteersViewModel>(context, listen: false)
          .setSearchQuery(value);
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _onSearchChanged('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск ...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white60),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text(
                'Волонтёры',
                style: TextStyle(color: Colors.white),
              ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Новые'),
            Tab(text: 'Отправленные'),
            Tab(text: 'Все'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchActive ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
        ],
        backgroundColor: const Color(0xFFF96800),
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/la_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNewVolunteersTab(),
            _buildSentVolunteersTab(),
            _buildAllVolunteersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF303030),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Image.asset(
                'assets/images/liza_alert_preview.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            ListTile(
              title: Text(
                _searchName == null ? 'Имя поиска' : 'Имя поиска: $_searchName',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: _showSearchNameDialog,
            ),
            ListTile(
              title: const Text('Волонтёры',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(color: Colors.grey),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: const Text(
                'Группы',
                style: TextStyle(
                  color: Color.fromARGB(255, 188, 188, 188),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...GroupCallsigns.values.map((groupCallsign) => ListTile(
                  title: Text(
                    groupCallsign.getGroupCallsignAsString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupTabsScreen(
                          groupCallsign:
                              groupCallsign.getGroupCallsignAsString(),
                        ),
                      ),
                    );
                  },
                )),
            const Divider(color: Colors.grey),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: const Text(
                'База данных',
                style: TextStyle(
                  color: Color.fromARGB(255, 188, 188, 188),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.save, color: Colors.white),
              title: const Text('Сохранить и переслать',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _saveAndShareData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewVolunteersTab() {
    return Column(
      children: [
        Expanded(
          child: _buildVolunteersList('Новые'),
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerRight,
            child: SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: const Color(0xFFF96800),
              iconTheme: const IconThemeData(color: Colors.black),
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.edit, color: Colors.white),
                  label: 'Добавить вручную',
                  backgroundColor: const Color(0xFFF96800),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddManuallyScreen(volunteerId: 0, size: '5'),
                    ),
                  ),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: 'Добавить с помощью QRScanner',
                  backgroundColor: const Color(0xFFF96800),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarCodeScannerScreen(),
                    ),
                  ),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.send, color: Colors.white),
                  label: 'Отправить новые инфоргу',
                  backgroundColor: const Color(0xFFF96800),
                  onTap: () async {
                    final viewModel = context.read<VolunteersViewModel>();
                    final volunteers =
                        viewModel.volunteers.where((v) => !v.isSent).toList();
                    if (volunteers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Нет новых волонтёров для отправки.')),
                      );
                      return;
                    }

                    final message = await viewModel
                        .formatVolunteersWithGroupNames(volunteers);

                    final bool wasShared = await sendVolunteersToInfo(message);

                    if (wasShared && mounted) {
                      await viewModel.markAllUnsentAsSent();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Успешно отправлено'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentVolunteersTab() {
    final viewModel = context.read<VolunteersViewModel>();
    return Column(
      children: [
        Expanded(
          child: _buildVolunteersList('Отправленные'),
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final volunteers = viewModel.volunteers
                    .where((v) => v.status == "Уехал")
                    .toList();
                if (volunteers.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Нет уехавших волонтёров для отправки.')),
                  );
                  return;
                }
                await sendVolunteersToInfo(
                    await viewModel.formatVolunteersWithGroupNames(volunteers));
              },
              backgroundColor: const Color(0xFFF96800),
              icon: const Icon(Icons.send,
                  color: Colors.black), // ← ДОБАВЬТЕ color: Colors.black
              label: const Text('Отправить инфоргу тех кто уехал',
                  style: TextStyle(color: Colors.black)), // ← ДОБАВЬТЕ style
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllVolunteersTab() {
    return Column(
      children: [
        Expanded(
          child: _buildVolunteersList('Все'),
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              onPressed: _showDeleteConfirmationDialog,
              backgroundColor: const Color(0xFFF96800),
              child: const Icon(Icons.delete, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteersList(String tabName) {
    return Consumer<VolunteersViewModel>(
      builder: (context, viewModel, child) {
        List<Volunteer> volunteers = [];
        switch (tabName) {
          case 'Новые':
            volunteers = viewModel.volunteers.where((v) => !v.isSent).toList();
            break;
          case 'Отправленные':
            volunteers = viewModel.volunteers.where((v) => v.isSent).toList();
            break;
          case 'Все':
            volunteers = viewModel.volunteers;
            break;
        }

        return ListView.builder(
          itemCount: volunteers.length,
          itemBuilder: (context, index) {
            final volunteer = volunteers[index];
            return VolunteerCard(
              volunteer: volunteer,
              groupName: volunteer.groupId?.toString(),
              onEdit: () {
                if (volunteer.uniqueId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ошибка: ID волонтера не найден')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddManuallyScreen(
                      volunteerId: volunteer.uniqueId!,
                      size: '5',
                    ),
                  ),
                );
              },
              onChangeStatus: () async {
                final newStatus =
                    volunteer.status == 'Активный' ? 'Уехал' : 'Активный';
                final updatedVolunteer = volunteer.copyWith(
                  status: newStatus,
                  isSent: newStatus == 'Активный' ? false : volunteer.isSent,
                );
                await viewModel.updateVolunteer(updatedVolunteer);

                if (tabName == 'Отправленные' && newStatus == 'Активный') {
                  setState(() {
                    _tabController.animateTo(0);
                  });
                }
              },
              onChangeTime: () async {
                final newTime = await _pickTime(volunteer.timeForSearch);
                if (newTime != null) {
                  await viewModel.updateVolunteer(
                      volunteer.copyWith(timeForSearch: newTime));
                }
              },
            );
          },
        );
      },
    );
  }

  void _showSearchNameDialog() {
    _nameSearchController.text = _searchName ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF303030),
        title: const Text('Введите имя поиска',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _nameSearchController,
          decoration: const InputDecoration(
            hintText: 'Имя поиска',
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            style:
                TextButton.styleFrom(backgroundColor: const Color(0xFFF96800)),
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style:
                TextButton.styleFrom(backgroundColor: const Color(0xFFF96800)),
            onPressed: () {
              final name = _nameSearchController.text.trim();
              setState(() {
                _searchName = name;
              });
              _saveSearchName(name);
              Navigator.pop(context);
            },
            child: const Text('ОК', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF303030),
        title:
            const Text('Предупреждение', style: TextStyle(color: Colors.white)),
        content: const Text('Подтвердите удаление всех записей',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              final volunteersViewModel =
                  Provider.of<VolunteersViewModel>(context, listen: false);
              final groupsViewModel =
                  Provider.of<GroupsViewModel>(context, listen: false);
              await volunteersViewModel.deleteAllVolunteers();
              await groupsViewModel.deleteArchivedGroups();
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
