import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';

class ActiveGroupsScreen extends StatefulWidget {
  final GroupCallsigns groupCallsign;
  final String searchQuery;

  const ActiveGroupsScreen({
    super.key,
    required this.groupCallsign,
    this.searchQuery = '',
  });

  @override
  State<ActiveGroupsScreen> createState() => _ActiveGroupsScreenState();
}

class _ActiveGroupsScreenState extends State<ActiveGroupsScreen> {
  late Future<List<Group>> _futureGroups;
  List<Group> _allGroups = [];
  List<Group> _filteredGroups = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.searchQuery.toLowerCase();
    _loadGroups();
  }

  @override
  void didUpdateWidget(covariant ActiveGroupsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchQuery = widget.searchQuery.toLowerCase();
      _applyFilter();
    }
  }

  void _loadGroups() {
    _futureGroups = Provider.of<GroupsViewModel>(context, listen: false)
        .getGroupByCallsignNotArchived(widget.groupCallsign.name);
    _futureGroups.then((groups) {
      setState(() {
        _allGroups = groups;
        _applyFilter();
      });
    });
  }

  void _applyFilter() {
    setState(() {
      _filteredGroups = _allGroups.where((group) {
        final groupName =
            '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}'
                .toLowerCase();
        return groupName.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Group>>(
        future: _futureGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (_filteredGroups.isEmpty) {
            return const Center(
              child: Text(
                'Нет активных групп',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: _filteredGroups.length,
            itemBuilder: (context, index) {
              final group = _filteredGroups[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Оборудование: ${group.navigators}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_group',
              arguments: widget.groupCallsign);
          _loadGroups(); // обновляем список после добавления
        },
        backgroundColor: const Color(0xFFF96800),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
