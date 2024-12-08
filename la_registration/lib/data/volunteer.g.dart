// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volunteer _$VolunteerFromJson(Map<String, dynamic> json) => Volunteer(
      uniqueId: (json['uniqueId'] as num).toInt(),
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      callSign: json['callSign'] as String? ?? "",
      nickName: json['nickName'] as String? ?? "",
      region: json['region'] as String? ?? "",
      car: json['car'] as String? ?? "",
      status: json['status'] as String? ?? "Active",
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$VolunteerToJson(Volunteer instance) => <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'callSign': instance.callSign,
      'nickName': instance.nickName,
      'region': instance.region,
      'car': instance.car,
      'status': instance.status,
      'size': instance.size,
    };
