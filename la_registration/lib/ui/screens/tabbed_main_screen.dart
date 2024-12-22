import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:la_registration/listeners/groups_viewmodel.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/ui/screens/group_tabs_screen.dart';
import 'package:la_registration/ui/screens/barcode_scanner_screen.dart';
import 'package:la_registration/ui/screens/add_manually_screen.dart';

class TabbedMainScreen extends StatefulWidget {
  const TabbedMainScreen({super.key});

  @override
  TabbedMainScreenState createState() => TabbedMainScreenState();
}

class TabbedMainScreenState extends State<TabbedMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchActive
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Поиск...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Add logic for filtering the list
                },
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
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Image.asset(
                'assets/images/liza_alert_preview.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            ListTile(
              title: const Text(
                'Имя поиска',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _showSearchNameDialog,
            ),
            ListTile(
              title: const Text(
                'Волонтёры',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.grey),
            Container(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Группы',
                  style: TextStyle(
                    color: Color.fromARGB(255, 188, 188, 188),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...GroupCallsigns.values.map((groupCallsign) {
              return ListTile(
                title: Text(
                  groupCallsign.getGroupCallsignAsString(),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupTabsScreen(
                        groupCallsign: groupCallsign.getGroupCallsignAsString(),
                      ),
                    ),
                  );
                },
              );
            }),
            const Divider(color: Colors.grey),
            Container(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'База данных',
                  style: TextStyle(
                    color: Color.fromARGB(255, 188, 188, 188),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Сохранить и переслать',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Save and send data logic
              },
            ),
            ListTile(
              title: const Text(
                'Загрузить базу данных',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Load database logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewVolunteersTab() {
    return Stack(
      children: [
        _buildVolunteersList(context, 'Новые'),
        Positioned(
          bottom: 16,
          right: 16,
          child: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: const Color(0xFFF96800),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.edit, color: Colors.white),
                label: 'Добавить вручную',
                backgroundColor: const Color(0xFFF96800),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddManuallyScreen(volunteerId: 0, size: '5'),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: 'Добавить с помощью QRScanner',
                backgroundColor: const Color(0xFFF96800),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarCodeScannerScreen(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.send, color: Colors.white),
                label: 'Отправить новые инфоргу',
                backgroundColor: const Color(0xFFF96800),
                onTap: () {
                  // Logic to send data
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSentVolunteersTab() {
    return Stack(
      children: [
        _buildVolunteersList(context, 'Отправленные'),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _showSendConfirmationDialog,
            backgroundColor: const Color(0xFFF96800),
            icon: const Icon(Icons.send),
            label: const Text('Отправить инфоргу тех кто уехал'),
          ),
        ),
      ],
    );
  }

  Widget _buildAllVolunteersTab() {
    return Stack(
      children: [
        _buildVolunteersList(context, 'Все'),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _showDeleteConfirmationDialog,
            backgroundColor: const Color(0xFFF96800),
            child: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear(); // Clear search field when closing
      }
    });
  }

  void _showSearchNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303030),
          title: const Text(
            'Введите имя поиска',
            style: TextStyle(color: Colors.white),
          ),
          content: const TextField(
            decoration: InputDecoration(
              hintText: 'Имя поиска',
              hintStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF96800),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF96800),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'ОК',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSendConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303030),
          title: const Text(
            'Подтвердите отправку инфоргу',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // Send confirmation logic
                Navigator.pop(context);
              },
              child: const Text(
                'Отправить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303030),
          title: const Text(
            'Предупреждение',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Подтвердите удаление всех записей',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // Logic for deleting all entries
                Navigator.pop(context);
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVolunteersList(BuildContext context, String tabName) {
    return Consumer<GroupsViewModel>(
      builder: (context, groupsViewModel, child) {
        final volunteers = groupsViewModel.groups;
        if (volunteers.isEmpty) {
          return Container(); // No data message removed
        }
        return ListView.builder(
          itemCount: volunteers.length,
          itemBuilder: (context, index) {
            final volunteer = volunteers[index];
            return ListTile(
              title: Text(
                volunteer.numberOfGroup.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                volunteer.details,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle volunteer item click
              },
            );
          },
        );
      },
    );
  }
}
