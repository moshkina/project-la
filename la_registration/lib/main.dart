import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'listeners/counter_viewmodel.dart';
import 'listeners/groups_viewmodel.dart';
import 'listeners/volunteers_viewmodel.dart';
import 'data/app_datastore_holder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatastoreHolder.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterViewModel()),
        ChangeNotifierProvider(create: (_) => GroupsViewModel()),
        ChangeNotifierProvider(create: (_) => VolunteersViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}
