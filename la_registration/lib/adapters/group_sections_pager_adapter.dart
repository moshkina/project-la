// import 'package:flutter/material.dart';
// import 'package:la_registration/ui/screens/group_detail_screen.dart';
// import 'package:la_registration/data/group.dart';

// class GroupSectionsPagerAdapter extends StatefulWidget {
//   final List<Group> groups;

//   // Конструктор должен быть const для обеспечения неизменяемости
//   const GroupSectionsPagerAdapter({super.key, required this.groups});

//   @override
//   GroupSectionsPagerAdapterState createState() =>
//       GroupSectionsPagerAdapterState();
// }

// class GroupSectionsPagerAdapterState extends State<GroupSectionsPagerAdapter>
//     with TickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: widget.groups.length, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Groups'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: List.generate(widget.groups.length, (index) {
//             return Tab(
//               text:
//                   'Group ${widget.groups[index].groupCallsign.nameOfGroup}', // Используем groupCallsign.nameOfGroup
//             );
//           }),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: List.generate(widget.groups.length, (index) {
//           final group = widget.groups[index];
//           return GroupDetailScreen(
//             groupId: group.id,
//             isGroupArchive: false,
//           );
//         }),
//       ),
//     );
//   }
// }
