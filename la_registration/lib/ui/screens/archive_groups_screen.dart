import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';

class ArchiveGroupsScreen extends StatelessWidget {
  final GroupCallsigns groupCallsign;

  const ArchiveGroupsScreen({super.key, required this.groupCallsign});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_group', arguments: groupCallsign);
        },
        backgroundColor: const Color(0xFFF96800), // Оранжевая кнопка
        shape: const CircleBorder(), // Круглая форма кнопки
        child: const Icon(
          Icons.add,
          color: Colors.white, // Белый плюс
        ),
      ),
      body: FutureBuilder<List<Group>>(
        future: Provider.of<GroupsViewModel>(context, listen: false)
            .getGroupByCallsignArchived(groupCallsign.name),
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

          final groups = snapshot.data ?? [];

          if (groups.isEmpty) {
            return const Center(
              child: Text(
                'Нет архивных групп',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Задача: ${group.navigators}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
