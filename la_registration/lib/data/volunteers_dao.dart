import 'package:floor/floor.dart';
import 'volunteer.dart';

@dao
abstract class VolunteersDao {
  @Query("SELECT * FROM volunteers ORDER BY `_index` ASC")
  Future<List<Volunteer>> getAllVolunteers();

  @Query("SELECT * FROM volunteers WHERE isSent = 1")
  Future<List<Volunteer>> getSentVolunteers();

  @Query("SELECT * FROM volunteers WHERE isSent = 0")
  Future<List<Volunteer>> getNotSentVolunteers();

  @Query("SELECT * FROM volunteers WHERE groupId IS NOT NULL")
  Future<List<Volunteer>> getAddedToGroupVolunteers();

  @Query("SELECT * FROM volunteers WHERE status = :status AND groupId IS NULL")
  Future<List<Volunteer>> getVolunteersByStatusAndNotAddedToGroup(
      String status);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertVolunteer(Volunteer volunteer);

  @update
  Future<void> updateVolunteer(Volunteer volunteer);

  @delete
  Future<void> deleteVolunteer(Volunteer volunteer);

  @Query("DELETE FROM volunteers")
  Future<void> deleteAllVolunteers();

  @Query("SELECT * FROM volunteers WHERE uniqueId = :id")
  Future<Volunteer?> getVolunteerById(int id);

  @Query(
      "SELECT * FROM volunteers WHERE status = :status AND notifyThatLeft = 0")
  Future<List<Volunteer>> getVolunteersWithStatus(String status);

  @Query(
      "SELECT COUNT(uniqueId) > 0 FROM volunteers WHERE fullName = :fullName AND phoneNumber = :phoneNumber")
  Future<bool> checkForVolunteerExist(String fullName, String phoneNumber);

  @Query("SELECT * FROM volunteers WHERE groupId = :idOfGroup")
  Future<List<Volunteer>> getVolunteersByIdOfGroup(int idOfGroup);

  @Query(
      "SELECT * FROM volunteers WHERE uniqueId IN (SELECT archivedVolunteerId FROM archived_groups_volunteers WHERE archivedGroupId = :idOfGroup)")
  Future<List<Volunteer>> getVolunteersByIdOfArchiveGroup(int idOfGroup);
}
