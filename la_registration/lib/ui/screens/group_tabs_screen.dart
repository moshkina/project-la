import 'package:flutter/material.dart';
import 'active_groups_screen.dart';
import 'archive_groups_screen.dart';

class GroupTabsScreen extends StatelessWidget {
  final String groupCallsign;

  const GroupTabsScreen({super.key, required this.groupCallsign});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Группы ($groupCallsign)'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Активные'),
              Tab(text: 'Архив'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ActiveGroupsScreen(groupCallsign: groupCallsign),
            ArchiveGroupsScreen(groupCallsign: groupCallsign),
          ],
        ),
      ),
    );
  }
}
