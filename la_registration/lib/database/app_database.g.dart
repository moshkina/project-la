// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GroupsDao? _groupsDaoInstance;

  VolunteersDao? _volunteersDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `groups` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `numberOfGroup` INTEGER NOT NULL, `elderOfGroupId` INTEGER NOT NULL, `navigators` TEXT NOT NULL, `cars` TEXT NOT NULL, `dateOfCreation` TEXT NOT NULL, `groupCallsign` INTEGER NOT NULL, `archived` TEXT NOT NULL, FOREIGN KEY (`elderOfGroupId`) REFERENCES `volunteers` (`uniqueId`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `volunteers` (`uniqueId` INTEGER PRIMARY KEY AUTOINCREMENT, `_index` INTEGER NOT NULL, `fullName` TEXT NOT NULL, `callSign` TEXT NOT NULL, `nickName` TEXT NOT NULL, `region` TEXT NOT NULL, `phoneNumber` TEXT NOT NULL, `car` TEXT NOT NULL, `isSent` INTEGER NOT NULL, `status` TEXT NOT NULL, `notifyThatLeft` TEXT NOT NULL, `timeForSearch` TEXT NOT NULL, `groupId` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GroupsDao get groupsDao {
    return _groupsDaoInstance ??= _$GroupsDao(database, changeListener);
  }

  @override
  VolunteersDao get volunteersDao {
    return _volunteersDaoInstance ??= _$VolunteersDao(database, changeListener);
  }
}

class _$GroupsDao extends GroupsDao {
  _$GroupsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _groupInsertionAdapter = InsertionAdapter(
            database,
            'groups',
            (Group item) => <String, Object?>{
                  'id': item.id,
                  'numberOfGroup': item.numberOfGroup,
                  'elderOfGroupId': item.elderOfGroupId,
                  'navigators': item.navigators,
                  'cars': item.cars,
                  'dateOfCreation': item.dateOfCreation,
                  'groupCallsign': item.groupCallsign.index,
                  'archived': item.archived
                }),
        _groupUpdateAdapter = UpdateAdapter(
            database,
            'groups',
            ['id'],
            (Group item) => <String, Object?>{
                  'id': item.id,
                  'numberOfGroup': item.numberOfGroup,
                  'elderOfGroupId': item.elderOfGroupId,
                  'navigators': item.navigators,
                  'cars': item.cars,
                  'dateOfCreation': item.dateOfCreation,
                  'groupCallsign': item.groupCallsign.index,
                  'archived': item.archived
                }),
        _groupDeletionAdapter = DeletionAdapter(
            database,
            'groups',
            ['id'],
            (Group item) => <String, Object?>{
                  'id': item.id,
                  'numberOfGroup': item.numberOfGroup,
                  'elderOfGroupId': item.elderOfGroupId,
                  'navigators': item.navigators,
                  'cars': item.cars,
                  'dateOfCreation': item.dateOfCreation,
                  'groupCallsign': item.groupCallsign.index,
                  'archived': item.archived
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Group> _groupInsertionAdapter;

  final UpdateAdapter<Group> _groupUpdateAdapter;

  final DeletionAdapter<Group> _groupDeletionAdapter;

  @override
  Future<List<Group>> getAllGroups() async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups ORDER BY groupCallsign',
        mapper: (Map<String, Object?> row) => Group(
            id: row['id'] as int,
            numberOfGroup: row['numberOfGroup'] as int,
            elderOfGroupId: row['elderOfGroupId'] as int,
            navigators: row['navigators'] as String,
            cars: row['cars'] as String,
            dateOfCreation: row['dateOfCreation'] as String,
            groupCallsign: GroupCallsigns.values[row['groupCallsign'] as int],
            archived: row['archived'] as String));
  }

  @override
  Future<List<Group>> getGroupsByCallsignNotArchived(
      GroupCallsigns groupCallsign) async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups WHERE groupCallsign = ?1 AND archived = \"false\"',
        mapper: (Map<String, Object?> row) => Group(id: row['id'] as int, numberOfGroup: row['numberOfGroup'] as int, elderOfGroupId: row['elderOfGroupId'] as int, navigators: row['navigators'] as String, cars: row['cars'] as String, dateOfCreation: row['dateOfCreation'] as String, groupCallsign: GroupCallsigns.values[row['groupCallsign'] as int], archived: row['archived'] as String),
        arguments: [groupCallsign.index]);
  }

  @override
  Future<List<Group>> getGroupsByCallsignArchived(
      GroupCallsigns groupCallsign) async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups WHERE groupCallsign = ?1 AND archived = \"true\"',
        mapper: (Map<String, Object?> row) => Group(
            id: row['id'] as int,
            numberOfGroup: row['numberOfGroup'] as int,
            elderOfGroupId: row['elderOfGroupId'] as int,
            navigators: row['navigators'] as String,
            cars: row['cars'] as String,
            dateOfCreation: row['dateOfCreation'] as String,
            groupCallsign: GroupCallsigns.values[row['groupCallsign'] as int],
            archived: row['archived'] as String),
        arguments: [groupCallsign.index]);
  }

  @override
  Future<int?> getLastNumberOfGroupByCallsign(
      GroupCallsigns groupCallsign) async {
    return _queryAdapter.query(
        'SELECT numberOfGroup FROM groups WHERE groupCallsign = ?1 ORDER BY numberOfGroup DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [groupCallsign.index]);
  }

  @override
  Future<void> deleteArchivedGroups() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM groups WHERE archived = "true"');
  }

  @override
  Future<Group?> getGroupById(int id) async {
    return _queryAdapter.query('SELECT * FROM groups WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Group(
            id: row['id'] as int,
            numberOfGroup: row['numberOfGroup'] as int,
            elderOfGroupId: row['elderOfGroupId'] as int,
            navigators: row['navigators'] as String,
            cars: row['cars'] as String,
            dateOfCreation: row['dateOfCreation'] as String,
            groupCallsign: GroupCallsigns.values[row['groupCallsign'] as int],
            archived: row['archived'] as String),
        arguments: [id]);
  }

  @override
  Future<int?> getGroupIdByNumber(int numberOfGroup) async {
    return _queryAdapter.query('SELECT id FROM groups WHERE numberOfGroup = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [numberOfGroup]);
  }

  @override
  Future<Group?> getArchivedGroupById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM groups      LEFT JOIN archived_groups_volunteers      ON archived_groups_volunteers.archivedGroupId = groups.id      LEFT JOIN volunteers      ON volunteers.uniqueId = archived_groups_volunteers.archivedVolunteerId      WHERE groups.id = ?1',
        mapper: (Map<String, Object?> row) => Group(id: row['id'] as int, numberOfGroup: row['numberOfGroup'] as int, elderOfGroupId: row['elderOfGroupId'] as int, navigators: row['navigators'] as String, cars: row['cars'] as String, dateOfCreation: row['dateOfCreation'] as String, groupCallsign: GroupCallsigns.values[row['groupCallsign'] as int], archived: row['archived'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertGroup(Group group) {
    return _groupInsertionAdapter.insertAndReturnId(
        group, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateGroup(Group group) {
    return _groupUpdateAdapter.updateAndReturnChangedRows(
        group, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteGroup(Group group) {
    return _groupDeletionAdapter.deleteAndReturnChangedRows(group);
  }
}

class _$VolunteersDao extends VolunteersDao {
  _$VolunteersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _volunteerInsertionAdapter = InsertionAdapter(
            database,
            'volunteers',
            (Volunteer item) => <String, Object?>{
                  'uniqueId': item.uniqueId,
                  '_index': item.index,
                  'fullName': item.fullName,
                  'callSign': item.callSign,
                  'nickName': item.nickName,
                  'region': item.region,
                  'phoneNumber': item.phoneNumber,
                  'car': item.car,
                  'isSent': item.isSent ? 1 : 0,
                  'status': item.status,
                  'notifyThatLeft': item.notifyThatLeft,
                  'timeForSearch': item.timeForSearch,
                  'groupId': item.groupId
                }),
        _volunteerUpdateAdapter = UpdateAdapter(
            database,
            'volunteers',
            ['uniqueId'],
            (Volunteer item) => <String, Object?>{
                  'uniqueId': item.uniqueId,
                  '_index': item.index,
                  'fullName': item.fullName,
                  'callSign': item.callSign,
                  'nickName': item.nickName,
                  'region': item.region,
                  'phoneNumber': item.phoneNumber,
                  'car': item.car,
                  'isSent': item.isSent ? 1 : 0,
                  'status': item.status,
                  'notifyThatLeft': item.notifyThatLeft,
                  'timeForSearch': item.timeForSearch,
                  'groupId': item.groupId
                }),
        _volunteerDeletionAdapter = DeletionAdapter(
            database,
            'volunteers',
            ['uniqueId'],
            (Volunteer item) => <String, Object?>{
                  'uniqueId': item.uniqueId,
                  '_index': item.index,
                  'fullName': item.fullName,
                  'callSign': item.callSign,
                  'nickName': item.nickName,
                  'region': item.region,
                  'phoneNumber': item.phoneNumber,
                  'car': item.car,
                  'isSent': item.isSent ? 1 : 0,
                  'status': item.status,
                  'notifyThatLeft': item.notifyThatLeft,
                  'timeForSearch': item.timeForSearch,
                  'groupId': item.groupId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Volunteer> _volunteerInsertionAdapter;

  final UpdateAdapter<Volunteer> _volunteerUpdateAdapter;

  final DeletionAdapter<Volunteer> _volunteerDeletionAdapter;

  @override
  Future<List<Volunteer>> getAllVolunteers() async {
    return _queryAdapter.queryList(
        'SELECT * FROM volunteers ORDER BY _index ASC',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?));
  }

  @override
  Future<List<Volunteer>> getSentVolunteers() async {
    return _queryAdapter.queryList(
        'SELECT * FROM volunteers WHERE isSent = \'true\'',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?));
  }

  @override
  Future<List<Volunteer>> getNotSentVolunteers() async {
    return _queryAdapter.queryList(
        'SELECT * FROM volunteers WHERE isSent =\'false\'',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?));
  }

  @override
  Future<List<Volunteer>> getAddedToGroupVolunteers() async {
    return _queryAdapter.queryList(
        'SELECT * FROM volunteers WHERE groupId IS NOT NULL',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?));
  }

  @override
  Future<List<Volunteer>> getVolunteersByStatusAndNotAddedToGroup(
      String status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM volunteers WHERE status = ?1 AND groupId IS NULL',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?),
        arguments: [status]);
  }

  @override
  Future<void> deleteAllVolunteers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM volunteers');
  }

  @override
  Future<Volunteer?> getVolunteerById(int id) async {
    return _queryAdapter.query('SELECT * FROM volunteers WHERE uniqueId = ?1',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Volunteer>> getVolunteersByGroupId(int groupId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM volunteers WHERE groupId = ?1',
        mapper: (Map<String, Object?> row) => Volunteer(
            uniqueId: row['uniqueId'] as int?,
            index: row['_index'] as int,
            fullName: row['fullName'] as String,
            callSign: row['callSign'] as String,
            nickName: row['nickName'] as String,
            region: row['region'] as String,
            phoneNumber: row['phoneNumber'] as String,
            car: row['car'] as String,
            isSent: (row['isSent'] as int) != 0,
            status: row['status'] as String,
            notifyThatLeft: row['notifyThatLeft'] as String,
            timeForSearch: row['timeForSearch'] as String,
            groupId: row['groupId'] as int?),
        arguments: [groupId]);
  }

  @override
  Future<void> insertVolunteer(Volunteer volunteer) async {
    await _volunteerInsertionAdapter.insert(
        volunteer, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateVolunteer(Volunteer volunteer) async {
    await _volunteerUpdateAdapter.update(volunteer, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteVolunteer(Volunteer volunteer) async {
    await _volunteerDeletionAdapter.delete(volunteer);
  }
}

// ignore_for_file: unused_element
final _converter = Converter();
