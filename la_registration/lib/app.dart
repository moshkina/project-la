import 'package:flutter/material.dart';
import 'ui/screens/tabbed_main_screen.dart';
import 'ui/screens/counter_screen.dart';
import 'ui/screens/add_group_screen.dart';
import 'ui/screens/group_detail_screen.dart';
import '../data/group_callsign.dart'; // Импорт для использования enum

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TabbedMainScreen(),
        '/counter': (context) => const CounterScreen(),
        '/add_group': (context) => const AddNewGroupScreen(
              groupId: 0,
              groupCallsign:
                  GroupCallsigns.bort, 
              isGroupEdit: false,
            ),
        '/group_details': (context) => const GroupDetailScreen(
              groupId: 1,
              isGroupArchive: false,
            ),
      },
    );
  }
}
