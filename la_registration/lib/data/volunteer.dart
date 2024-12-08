import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'volunteer.g.dart'; // Для генерации кода с помощью json_serializable

@Entity(tableName: 'volunteers')
@JsonSerializable()
class Volunteer {
  @PrimaryKey(autoGenerate: true)
  final int uniqueId; // Уникальный идентификатор для волонтера

  final String fullName; // Полное имя волонтера
  final String phoneNumber; // Номер телефона
  final String callSign; // Позывной
  final String nickName; // Псевдоним
  final String region; // Регион
  final String car; // Машина
  String status; // Статус
  final int size; // Размер одежды

  // Конструктор
  Volunteer({
    required this.uniqueId,
    required this.fullName,
    required this.phoneNumber,
    this.callSign = "",
    this.nickName = "",
    this.region = "",
    this.car = "",
    this.status = "Active",
    required this.size,
  });

  // Фабрика для десериализации
  factory Volunteer.fromJson(Map<String, dynamic> json) =>
      _$VolunteerFromJson(json);

  // Метод для сериализации
  Map<String, dynamic> toJson() => _$VolunteerToJson(this);
}
