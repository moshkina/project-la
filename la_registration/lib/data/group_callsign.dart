enum GroupCallsigns {
  bort("Борт"),
  kinolog("Кинолог"),
  veter("Ветер"),
  voda("Вода"),
  pegas("Пегас"),
  police("Полиция"),
  mchs("МЧС"),
  pso("ПСО"),
  lisa("Лиса"),
  autonome("Автоном");

  final String nameOfGroup;

  const GroupCallsigns(this.nameOfGroup);

  /// Метод для получения элемента перечисления по строковому значению
  static GroupCallsigns? fromString(String name) {
    try {
      return GroupCallsigns.values.firstWhere(
        (e) => e.nameOfGroup.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null; // Если не найдено, возвращаем null
    }
  }

  // Метод для получения строки с названием группы
  String getGroupCallsignAsString() {
    return nameOfGroup; // Возвращаем название группы
  }
}
