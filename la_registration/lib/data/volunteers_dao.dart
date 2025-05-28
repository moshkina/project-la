import 'package:floor/floor.dart';
import 'volunteer.dart';

// part 'volunteers_dao.g.dart'; 
@dao
abstract class VolunteersDao {
  @Query("SELECT * FROM volunteers ORDER BY _index ASC")
  Future<List<Volunteer>> getAllVolunteers();

  @Query("SELECT * FROM volunteers WHERE isSent = 'true'")
  Future<List<Volunteer>> getSentVolunteers();

  @Query("SELECT * FROM volunteers WHERE isSent ='false'")
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

  @Query("SELECT * FROM volunteers WHERE groupId = :groupId")
  Future<List<Volunteer>> getVolunteersByGroupId(int groupId);
}
