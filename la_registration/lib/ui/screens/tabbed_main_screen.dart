import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Волонтёры'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Новые'),
            Tab(text: 'Отправленные'),
            Tab(text: 'Все'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog, // Показать диалог поиска
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Меню',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Итерация через все типы групп
            ...GroupCallsigns.values.map((groupCallsign) {
              return ListTile(
                title: Text(groupCallsign.getGroupCallsignAsString()),
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
            ListTile(
              title: const Text('Сканировать QR код'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BarCodeScannerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Добавить вручную'),
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVolunteersList(context, 'Новые'),
          _buildVolunteersList(context, 'Отправленные'),
          _buildVolunteersList(context, 'Все'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddManuallyScreen(volunteerId: 0, size: '5'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVolunteersList(BuildContext context, String tabName) {
    return Consumer<GroupsViewModel>(
      builder: (context, groupsViewModel, child) {
        final volunteers = groupsViewModel.groups;
        if (volunteers.isEmpty) {
          return Center(
            child: Text('Нет данных для вкладки $tabName'),
          );
        }

        return ListView.builder(
          itemCount: volunteers.length,
          itemBuilder: (context, index) {
            final volunteer = volunteers[index];
            return ListTile(
              title: Text(volunteer.numberOfGroup.toString()),
              subtitle: Text(volunteer.details),
              onTap: () {
                // Обработка нажатия на волонтёра
              },
            );
          },
        );
      },
    );
  }

  // Метод для отображения диалогового окна поиска
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Поиск групп'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(labelText: 'Введите название группы'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Добавить логику поиска
                Navigator.of(context).pop();
              },
              child: const Text('Поиск'),
            ),
          ],
        );
      },
    );
  }
}
