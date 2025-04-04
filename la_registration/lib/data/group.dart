import 'package:floor/floor.dart'; // Оставляем только нужные импорты
import '../data/group_callsign.dart'; // Убедитесь, что путь импорта правильный
import '../converters/converter.dart'; // Импортируем конвертер
import 'volunteer.dart'; // Импортируем модель волонтера

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
@TypeConverters([Converter]) // Применяем TypeConverter для всего класса
class Group {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int numberOfGroup;
  final int elderOfGroupId; // Nullable field for elder
  final String navigators;
  final String cars;
  final String dateOfCreation;
  final GroupCallsigns groupCallsign; // Используем enum GroupCallsigns
  final String archived;

  // final List<Volunteer>? searchers; // Добавляем поле для поиска волонтёров

  Group({
    required this.id,
    required this.numberOfGroup,
    required this.elderOfGroupId,
    this.navigators = '',
    this.cars = '',
    required this.dateOfCreation,
    required this.groupCallsign, // Теперь принимаем enum GroupCallsigns
    this.archived = 'false',
    // this.searchers, // Опциональный параметр для поиска волонтёров
  });

  // Новый геттер для подсчета участников (можно использовать для подсчета поисковиков)
  // int get membersCount {
  //   return searchers?.length ?? 0; // Подсчитываем участников, если они есть
  // }

  // Метод copyWith, который позволяет создавать новый объект с измененными полями
  Group copyWith({
    int? id,
    int? numberOfGroup,
    int? elderOfGroupId,
    String? navigators,
    String? cars,
    String? dateOfCreation,
    GroupCallsigns? groupCallsign,
    String? archived,
    // List<Volunteer>? searchers,
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
      // searchers: searchers ?? this.searchers,
    );
  }
}
