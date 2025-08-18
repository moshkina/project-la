import 'package:flutter/material.dart';
import 'ui/screens/tabbed_main_screen.dart';
import 'ui/screens/counter_screen.dart';
import 'ui/screens/add_group_screen.dart';
import 'ui/screens/group_detail_screen.dart';
import '../data/group_callsign.dart';

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
        '/add_group': (context) {
  final args = ModalRoute.of(context)?.settings.arguments as GroupCallsigns?;
  return AddNewGroupScreen(
    groupId: 0,
    groupCallsign: args ?? GroupCallsigns.kinolog,
    isGroupEdit: false,
  );
},
        '/group_details': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return GroupDetailScreen(
      groupId: args?['groupId'] ?? 0, // 0 - значение по умолчанию, если не передано
      isGroupArchive: args?['isGroupArchive'] ?? false,
    );
  },
      },
    );
  }
}
