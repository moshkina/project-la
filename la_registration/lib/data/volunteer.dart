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
  final String additionalInfo;
  final bool isSent;
  String status;
  final String notifyThatLeft;
  String timeForSearch;
  final int? groupId;

  Volunteer({
    this.uniqueId,
    required this.index,
    required this.fullName,
    this.callSign = "",
    this.nickName = "",
    this.region = "",
    required this.phoneNumber,
    this.car = "",
    this.additionalInfo = "",
    this.isSent = false,
    this.status = "Active",
    this.notifyThatLeft = "false",
    this.timeForSearch = "",
    this.groupId,
  });

  @override
  String toString() => "$fullName ($callSign)";
  static const _noChange = Object();

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
      'additionalInfo': additionalInfo,
      'isSent': isSent,
      'status': status,
      'notifyThatLeft': notifyThatLeft,
      'timeForSearch': timeForSearch,
      'groupId': groupId,
    };
  }

  Volunteer copyWith({
    int? uniqueId,
    int? index,
    String? fullName,
    String? callSign,
    String? nickName,
    String? region,
    String? phoneNumber,
    String? car,
    String? additionalInfo,
    bool? isSent,
    String? status,
    String? notifyThatLeft,
    String? timeForSearch,
    Object? groupId = _noChange,
  }) {
    return Volunteer(
      uniqueId: uniqueId ?? this.uniqueId,
      index: index ?? this.index,
      fullName: fullName ?? this.fullName,
      callSign: callSign ?? this.callSign,
      nickName: nickName ?? this.nickName,
      region: region ?? this.region,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      car: car ?? this.car,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isSent: isSent ?? this.isSent,
      status: status ?? this.status,
      notifyThatLeft: notifyThatLeft ?? this.notifyThatLeft,
      timeForSearch: timeForSearch ?? this.timeForSearch,
      groupId: groupId == _noChange ? this.groupId : groupId as int?,
    );
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
      additionalInfo: json['additionalInfo'] as String? ?? '',
      isSent: json['isSent'] as bool? ?? false,
      status: json['status'] as String? ?? 'Active',
      notifyThatLeft: json['notifyThatLeft'] as String? ?? 'false',
      timeForSearch: json['timeForSearch'] as String? ?? '',
      groupId: json['groupId'] as int?,
    );
  }
}
