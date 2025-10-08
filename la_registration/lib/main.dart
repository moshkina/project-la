import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'listeners/counter_viewmodel.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import 'data/app_datastore_holder.dart';
import 'database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatastoreHolder.init();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  await _addAdditionalInfoField(database);
  final groupsDao = database.groupsDao;
  final volunteersDao = database.volunteersDao;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterViewModel()),
        ChangeNotifierProvider(
            create: (_) => GroupsViewModel(groupsDao, volunteersDao)),
        ChangeNotifierProvider(
            create: (_) => VolunteersViewModel(volunteersDao, groupsDao)),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _addAdditionalInfoField(AppDatabase database) async {
  try {
    final tableInfo =
        await database.database.rawQuery("PRAGMA table_info(volunteers)");
    final fieldExists =
        tableInfo.any((column) => column['name'] == 'additionalInfo');

    if (!fieldExists) {
      await database.database.execute(
          'ALTER TABLE volunteers ADD COLUMN additionalInfo TEXT NOT NULL DEFAULT ""');
    }
  } catch (e) {
    debugPrint('Ошибка при добавлении поля additionalInfo: $e');
  }
}
