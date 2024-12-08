import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/listeners/groups_viewmodel.dart';
import 'group_detail_screen.dart';
import 'add_group_screen.dart';
import 'barcode_scanner_screen.dart';
import 'add_manually_screen.dart';
import 'package:la_registration/data/group_callsign.dart'; // Ensure GroupCallsigns enum is imported

class TabbedMainScreen extends StatefulWidget {
  const TabbedMainScreen({super.key});

  @override
  TabbedMainScreenState createState() => TabbedMainScreenState();
}

class TabbedMainScreenState extends State<TabbedMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabbed Main Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Логика для поиска
              showSearch(
                context: context,
                delegate: GroupSearchDelegate(),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Groups'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroupDetailScreen(
                      groupId: 1,
                      isGroupArchive: false,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Add Group'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewGroupScreen(
                      groupId: 0,
                      groupCallsign: GroupCallsigns.bort, // Use enum value here
                      isGroupEdit: false,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Scan QR Code'),
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
              title: const Text('Add Manually'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddManuallyScreen(
                      volunteerId: 0,
                      size: 5,
                    ),
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
                title: Text(
                    group.numberOfGroup.toString()), // Convert number to string
                subtitle: Text(group.details),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetailScreen(
                        groupId: group.id,
                        isGroupArchive: false,
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

class GroupSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Here you can display search results
    return Center(
      child: Text('Search results for "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Here you can display suggestions based on user input
    return ListView(
      children: [
        ListTile(
          title: const Text('Suggestion 1'),
          onTap: () {
            query = 'Suggestion 1';
            showResults(context);
          },
        ),
        ListTile(
          title: const Text('Suggestion 2'),
          onTap: () {
            query = 'Suggestion 2';
            showResults(context);
          },
        ),
      ],
    );
  }
}
