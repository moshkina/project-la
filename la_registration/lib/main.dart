import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'listeners/counter_viewmodel.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart'; // Для нового класса
import 'data/app_datastore_holder.dart';
import 'database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatastoreHolder.init();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final groupsDao = database.groupsDao;
  final volunteersDao = database.volunteersDao;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterViewModel()),
        ChangeNotifierProvider(create: (_) => GroupsViewModel(groupsDao)),
        ChangeNotifierProvider(
            create: (_) => VolunteersViewModel(volunteersDao, groupsDao)),
      ],
      child: const MyApp(),
    ),
  );
}
