import 'package:floor/floor.dart';

@Entity(tableName: "volunteers")
class Volunteer {
  @PrimaryKey(autoGenerate: true)
  final int? uniqueId;

  @ColumnInfo(name: "_index")
  final int index;

  final String fullName;
  final String callSign;
  final String nickName;
  final String region;
  final String phoneNumber;
  final String car;
  final bool isSent;
  String status;
  final String notifyThatLeft;
  String timeForSearch;
  final int? groupId;

  Volunteer({
    this.uniqueId, // теперь необязательный — Floor сам сгенерирует
    required this.index,
    required this.fullName,
    this.callSign = "",
    this.nickName = "",
    this.region = "",
    required this.phoneNumber,
    this.car = "",
    this.isSent = false,
    this.status = "Active",
    this.notifyThatLeft = "false",
    this.timeForSearch = "",
    this.groupId,
  });

  @override
  String toString() => "$fullName ($callSign)";

  Map<String, dynamic> toJson() {
    return {
      'uniqueId': uniqueId,
      'index': index,
      'fullName': fullName,
      'callSign': callSign,
      'nickName': nickName,
      'region': region,
      'phoneNumber': phoneNumber,
      'car': car,
      'isSent': isSent,
      'status': status,
      'notifyThatLeft': notifyThatLeft,
      'timeForSearch': timeForSearch,
      'groupId': groupId,
    };
  }

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      uniqueId: json['uniqueId'] as int?,
      index: json['index'] as int,
      fullName: json['fullName'] as String,
      callSign: json['callSign'] as String? ?? '',
      nickName: json['nickName'] as String? ?? '',
      region: json['region'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String,
      car: json['car'] as String? ?? '',
      isSent: json['isSent'] as bool? ?? false,
      status: json['status'] as String? ?? 'Active',
      notifyThatLeft: json['notifyThatLeft'] as String? ?? 'false',
      timeForSearch: json['timeForSearch'] as String? ?? '',
      groupId: json['groupId'] as int?,
    );
  }
}
