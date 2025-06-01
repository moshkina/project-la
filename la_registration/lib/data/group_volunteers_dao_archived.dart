import 'package:floor/floor.dart';
import 'group.dart';
import 'volunteer.dart';

@Entity(
  tableName: 'archived_groups_volunteers',
  primaryKeys: ['archivedGroupId', 'archivedVolunteerId'],
  foreignKeys: [
    ForeignKey(
      entity: Group,
      parentColumns: ['id'],
      childColumns: ['archivedGroupId'],
    ),
    ForeignKey(
      entity: Volunteer,
      parentColumns: ['uniqueId'],
      childColumns: ['archivedVolunteerId'],
    ),
  ],
)
class ArchivedGroupsVolunteers {
  final int archivedGroupId;
  final int archivedVolunteerId;

  ArchivedGroupsVolunteers({
    required this.archivedGroupId,
    required this.archivedVolunteerId,
  });
}
