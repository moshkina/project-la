import 'package:flutter/material.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/ui/screens/active_groups_screen.dart';
import 'package:la_registration/ui/screens/archive_groups_screen.dart';

class GroupTabsScreen extends StatelessWidget {
  final String groupCallsign;

  const GroupTabsScreen({super.key, required this.groupCallsign});

  @override
  Widget build(BuildContext context) {
    final callsign = GroupCallsigns.fromString(groupCallsign);

    if (callsign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: const Center(child: Text('Некорректный позывной группы')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Группы (${callsign.nameOfGroup})',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFF96800),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Активные'),
              Tab(text: 'Архив'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ActiveGroupsScreen(groupCallsign: callsign),
            ArchiveGroupsScreen(groupCallsign: callsign),
          ],
        ),
      ),
    );
  }
}
