// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:la_registration/data/group.dart';
// import 'package:la_registration/data/group_callsign.dart';
// import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';

// class ActiveGroupsScreen extends StatefulWidget {
//   final GroupCallsigns groupCallsign;

//   const ActiveGroupsScreen({super.key, required this.groupCallsign});

//   @override
//   State<ActiveGroupsScreen> createState() => _ActiveGroupsScreenState();
// }

// class _ActiveGroupsScreenState extends State<ActiveGroupsScreen> {
//   late Future<List<Group>> _futureGroups;

//   @override
//   void initState() {
//     super.initState();
//     _loadGroups();
//   }

//   void _loadGroups() {
//     _futureGroups = Provider.of<GroupsViewModel>(context, listen: false)
//         .getGroupByCallsignNotArchived(widget.groupCallsign.name);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.pushNamed(context, '/add_group',
//               arguments: widget.groupCallsign);
//           _loadGroups(); // пересоздаём future
//           setState(() {}); // триггерим перерисовку
//         },
//         backgroundColor: const Color(0xFFF96800),
//         shape: const CircleBorder(),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       body: FutureBuilder<List<Group>>(
//         future: _futureGroups,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Ошибка: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           final groups = snapshot.data ?? [];

//           if (groups.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Нет активных групп',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: groups.length,
//             itemBuilder: (context, index) {
//               final group = groups[index];
//               return Card(
//                 color: Colors.grey[900],
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: ListTile(
//                   title: Text(
//                     '${group.groupCallsign.getGroupCallsignAsString()} №${group.numberOfGroup}',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Text(
//                     'Оборудование: ${group.navigators}',
//                     style: const TextStyle(color: Colors.white70),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/data/group_callsign.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import '../widgets/group_card.dart'; // путь к GroupCard (подкорректируйте под ваш проект)

class ActiveGroupsScreen extends StatefulWidget {
  final GroupCallsigns groupCallsign;

  const ActiveGroupsScreen({super.key, required this.groupCallsign});

  @override
  State<ActiveGroupsScreen> createState() => _ActiveGroupsScreenState();
}

class _ActiveGroupsScreenState extends State<ActiveGroupsScreen> {
  late Future<List<Group>> _futureGroups;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    _futureGroups = Provider.of<GroupsViewModel>(context, listen: false)
        .getGroupByCallsignNotArchived(widget.groupCallsign.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_group',
              arguments: widget.groupCallsign);
          _loadGroups();
          setState(() {});
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

          final groups = snapshot.data ?? [];

          if (groups.isEmpty) {
            return const Center(
              child: Text(
                'Нет активных групп',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GroupCard(
                group: group,
                isArchived: false,
              );
            },
          );
        },
      ),
    );
  }
}
