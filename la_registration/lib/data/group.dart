import 'package:floor/floor.dart';
import '../data/group_callsign.dart';
import '../converters/converter.dart';
import 'volunteer.dart';

@Entity(
  tableName: 'groups',
  foreignKeys: [
    ForeignKey(
      entity: Volunteer,
      parentColumns: ['uniqueId'],
      childColumns: ['elderOfGroupId'],
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
@TypeConverters([Converter])
class Group {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int numberOfGroup;
  final int elderOfGroupId;
  final String navigators;
  final String cars;
  final String dateOfCreation;
  final GroupCallsigns groupCallsign;
  final String archived;
  final String? task;
  final String? radios;
  final String? compasses;
  final String? flashlights;
  final String? otherEquipment;
  final String? notes;

  Group({
    this.id,
    required this.numberOfGroup,
    required this.elderOfGroupId,
    this.navigators = '',
    this.cars = '',
    required this.dateOfCreation,
    required this.groupCallsign,
    this.archived = 'false',
    this.task,
    this.radios = '',
    this.compasses = '',
    this.flashlights = '',
    this.otherEquipment = '',
    this.notes = '',
  });
  String getGroupDisplayName() {
    final callsign = groupCallsign.getGroupCallsignAsString();
    final number = numberOfGroup;
    final status = archived == 'true' ? ' (архив)' : '';
    return '$callsign №$number$status';
  }

  Group copyWith({
    int? id,
    int? numberOfGroup,
    int? elderOfGroupId,
    String? navigators,
    String? cars,
    String? dateOfCreation,
    GroupCallsigns? groupCallsign,
    String? archived,
    String? task,
    String? radios,
    String? compasses,
    String? flashlights,
    String? otherEquipment,
    String? notes,
  }) {
    return Group(
      id: id ?? this.id,
      numberOfGroup: numberOfGroup ?? this.numberOfGroup,
      elderOfGroupId: elderOfGroupId ?? this.elderOfGroupId,
      navigators: navigators ?? this.navigators,
      cars: cars ?? this.cars,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      groupCallsign: groupCallsign ?? this.groupCallsign,
      archived: archived ?? this.archived,
      task: task ?? this.task,
      radios: radios ?? this.radios,
      compasses: compasses ?? this.compasses,
      flashlights: flashlights ?? this.flashlights,
      otherEquipment: otherEquipment ?? this.otherEquipment,
      notes: notes ?? this.notes,
    );
  }
}
