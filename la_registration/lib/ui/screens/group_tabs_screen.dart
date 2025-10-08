import 'package:flutter/material.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/ui/screens/active_groups_screen.dart';
import 'package:la_registration/ui/screens/archive_groups_screen.dart';

class GroupTabsScreen extends StatefulWidget {
  final String groupCallsign;

  const GroupTabsScreen({super.key, required this.groupCallsign});

  @override
  GroupTabsScreenState createState() => GroupTabsScreenState();
}

class GroupTabsScreenState extends State<GroupTabsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim();
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
    final callsign = GroupCallsigns.fromString(widget.groupCallsign);

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
          title: _isSearchActive
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Поиск групп...',
                    hintStyle: TextStyle(color: Colors.white60),
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  onChanged: _onSearchChanged,
                )
              : Text(
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
          actions: [
            IconButton(
              icon: Icon(
                _isSearchActive ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ActiveGroupsScreen(
              groupCallsign: callsign,
              searchQuery: _searchQuery,
            ),
            ArchiveGroupsScreen(
              groupCallsign: callsign,
              searchQuery: _searchQuery,
            ),
          ],
        ),
      ),
    );
  }
}
