import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import '../widgets/group_card.dart';

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

  Future<Volunteer?> _getElderForGroup(
      BuildContext context, Group group) async {
    try {
      final volunteersViewModel = context.read<VolunteersViewModel>();
      return await volunteersViewModel.getVolunteerById(group.elderOfGroupId);
    } catch (e) {
      return null;
    }
  }

  void _loadGroups() {
    _futureGroups = Provider.of<GroupsViewModel>(context, listen: false)
        .getGroupByCallsignNotArchived(widget.groupCallsign.name);
    _futureGroups.then((groups) {
      if (mounted) {
        setState(() {
          _allGroups = groups;
          _applyFilter();
        });
      }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/add_group',
            arguments: widget.groupCallsign,
          );
          // После возврата из добавления группы перезагружаем данные
          _loadGroups();
        },
        backgroundColor: const Color(0xFFF96800),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
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

          final groups = _searchQuery.isEmpty ? _allGroups : _filteredGroups;

          if (groups.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isEmpty
                    ? 'Нет активных групп'
                    : 'Группы не найдены',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadGroups();
            },
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return FutureBuilder<Volunteer?>(
                  future: _getElderForGroup(context, group),
                  builder: (context, elderSnapshot) {
                    if (elderSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return GroupCard(
                      group: group,
                      isArchived: false,
                      elder: elderSnapshot.data,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
