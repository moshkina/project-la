import 'dart:convert';
import '../data/group_callsign.dart';
import '../data/volunteer.dart';

class Converter {
  // Преобразование списка волонтеров в строку (JSON)
  String listVolunteersToString(List<Volunteer> volunteers) {
    return json.encode(volunteers.map((v) => v.toJson()).toList());
  }

  // Преобразование строки (JSON) в список волонтеров
  List<Volunteer> stringToListVolunteers(String listVolunteersAsString) {
    var decodedList = json.decode(listVolunteersAsString) as List;
    return decodedList.map((item) => Volunteer.fromJson(item)).toList();
  }

  // Преобразование одного волонтера в строку (JSON)
  String volunteerToString(Volunteer volunteer) {
    return json.encode(volunteer.toJson());
  }

  // Преобразование строки (JSON) в одного волонтера
  Volunteer stringToVolunteer(String volunteerAsString) {
    return Volunteer.fromJson(json.decode(volunteerAsString));
  }

  // Преобразование списка идентификаторов в строку (JSON)
  String listIntToString(List<int> ids) {
    return json.encode(ids);
  }

  // Преобразование строки (JSON) в список идентификаторов
  List<int> stringToListInt(String listIdsAsString) {
    return List<int>.from(json.decode(listIdsAsString));
  }

  // Преобразование группы в строку (JSON)
  String groupToString(GroupCallsigns group) {
    return json.encode(group.nameOfGroup);
  }

  // Преобразование строки (JSON) в группу
  GroupCallsigns stringToGroup(String groupAsString) {
    return GroupCallsigns.values
        .firstWhere((e) => e.nameOfGroup == groupAsString);
  }
}
