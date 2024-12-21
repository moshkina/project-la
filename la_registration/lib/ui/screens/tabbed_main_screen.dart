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

class TabbedMainScreenState extends State<TabbedMainScreen> {
  String searchName = ''; // Переменная для хранения имени для поиска
  late GroupsViewModel groupsViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupsViewModel = Provider.of<GroupsViewModel>(context);
  }

  // Метод для отображения диалогового окна поиска
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: searchName);
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
                setState(() {
                  searchName = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Поиск'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главный экран'),
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
      body: Consumer<GroupsViewModel>(
        builder: (context, groupsViewModel, child) {
          return ListView.builder(
            itemCount: groupsViewModel.groups.length,
            itemBuilder: (context, index) {
              final group = groupsViewModel.groups[index];
              return ListTile(
                title: Text(group.numberOfGroup.toString()),
                subtitle: Text(group.details),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupTabsScreen(
                        groupCallsign:
                            group.groupCallsign.getGroupCallsignAsString(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
