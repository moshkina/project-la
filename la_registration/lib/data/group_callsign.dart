enum GroupCallsigns {
  bort("Bort"),
  kinolog("Kinolog"),
  veter("Veter"),
  voda("Voda"),
  pegas("Pegas"),
  police("Police"),
  mchs("Mchs"),
  pso("Pso"),
  lisa("Lisa"),
  autonome("Autonome");

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
}
