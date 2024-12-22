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
          title: Text(
            'Группы ($groupCallsign)',
            style:
                const TextStyle(color: Colors.white), // Белый текст заголовка
          ),
          backgroundColor: const Color(0xFFF96800), // Оранжевый фон для appBar
          bottom: const TabBar(
            labelColor: Colors.white, // Белый текст на активной вкладке
            unselectedLabelColor:
                Colors.white, // Белый текст на неактивной вкладке
            indicatorColor: Colors.white, // Белый ползунок между вкладками
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold, // Жирный текст на активной вкладке
            ),
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
