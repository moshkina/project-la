import 'package:floor/floor.dart';
import 'group.dart';
import 'group_callsign.dart';

@dao
abstract class GroupsDao {
  @Query('SELECT * FROM groups ORDER BY groupCallsign')
  Future<List<Group>> getAllGroups();

  @Query(
      'SELECT * FROM groups WHERE groupCallsign = :groupCallsign AND archived = "false"')
  Future<List<Group>> getGroupsByCallsignNotArchived(
      GroupCallsigns groupCallsign);

  @Query(
      'SELECT * FROM groups WHERE groupCallsign = :groupCallsign AND archived = "true"')
  Future<List<Group>> getGroupsByCallsignArchived(GroupCallsigns groupCallsign);

  @Query(
      'SELECT numberOfGroup FROM groups WHERE groupCallsign = :groupCallsign ORDER BY numberOfGroup DESC LIMIT 1')
  Future<int?> getLastNumberOfGroupByCallsign(GroupCallsigns groupCallsign);

  @insert
  Future<int> insertGroup(Group group);

  @delete
  Future<void> deleteGroup(Group group);

  @Query('DELETE FROM groups')
  Future<void> deleteAllGroups();

  @update
  Future<void> updateGroup(Group group);

  @Query('SELECT * FROM groups WHERE id = :id')
  Future<Group?> getGroupById(int id);

  @Query('SELECT id FROM groups WHERE numberOfGroup = :numberOfGroup')
  Future<int?> getGroupIdByNumber(int numberOfGroup);

  @Query('''
    SELECT * FROM groups 
    LEFT JOIN archived_groups_volunteers 
    ON archived_groups_volunteers.archivedGroupId = groups.id 
    LEFT JOIN volunteers 
    ON volunteers.uniqueId = archived_groups_volunteers.archivedVolunteerId 
    WHERE groups.id = :id
  ''')
  Future<Group?> getArchivedGroupById(int id);
}
