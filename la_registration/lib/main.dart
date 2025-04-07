import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'listeners/counter_viewmodel.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart'; // Для нового класса
import 'data/app_datastore_holder.dart';
// import 'data/groups_dao.dart'; // Импорт DAO
// import 'data/volunteers_dao.dart'; // Импорт DAO
import 'database/app_database.dart'; // Импорт базы данных

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatastoreHolder.init();

  // Инициализация базы данных, с помощью которой будут получены DAO
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final groupsDao =
      database.groupsDao; // Получаем DAO для групп через базу данных
  final volunteersDao =
      database.volunteersDao; // Получаем DAO для волонтёров через базу данных

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterViewModel()),
        ChangeNotifierProvider(
            create: (_) => GroupsViewModel(
                groupsDao)), // Передаем groupsDao в GroupsViewModel
        ChangeNotifierProvider(
            create: (_) => VolunteersViewModel(
                volunteersDao)), // Передаем volunteersDao в VolunteersViewModel
      ],
      child: const MyApp(),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'app.dart';
// import 'listeners/counter_viewmodel.dart';
// import 'data/app_datastore_holder.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await AppDatastoreHolder.init();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CounterViewModel()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
