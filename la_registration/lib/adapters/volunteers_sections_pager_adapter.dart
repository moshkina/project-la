// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:la_registration/ui/screens/volunteer_detail_screen.dart';
// import 'package:la_registration/data/volunteer.dart';
// import 'package:la_registration/listeners/volunteers_viewmodel.dart';

// class VolunteersSectionsPagerAdapter extends StatelessWidget {
//   final VolunteersViewModel volunteersViewModel;

//   const VolunteersSectionsPagerAdapter({
//     super.key,
//     required this.volunteersViewModel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Две вкладки: Active и Archived
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Volunteers'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Active Volunteers'),
//               Tab(text: 'Archived Volunteers'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Список активных волонтеров
//             Consumer<VolunteersViewModel>(
//               builder: (context, viewModel, child) {
//                 return ListView.builder(
//                   itemCount: viewModel.activeVolunteers.length,
//                   itemBuilder: (context, index) {
//                     Volunteer volunteer = viewModel.activeVolunteers[index];
//                     return ListTile(
//                       title: Text(
//                           volunteer.fullName), // Исправлено с name на fullName
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => VolunteerDetailScreen(
//                               volunteer: volunteer,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//             // Список архивных волонтеров
//             Consumer<VolunteersViewModel>(
//               builder: (context, viewModel, child) {
//                 return ListView.builder(
//                   itemCount: viewModel.archivedVolunteers.length,
//                   itemBuilder: (context, index) {
//                     Volunteer volunteer = viewModel.archivedVolunteers[index];
//                     return ListTile(
//                       title: Text(
//                           volunteer.fullName), // Исправлено с name на fullName
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => VolunteerDetailScreen(
//                               volunteer: volunteer,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
