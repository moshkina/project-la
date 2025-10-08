enum GroupCallsigns {
  autonome("Автоном"),
  lisa("Лиса"),
  veter("Ветер"),
  kinolog("Кинолог"),
  bort("Борт"),
  pso("ПСО"),
  police("Полиция"),
  mchs("МЧС"),
  pegas("Пегас"),
  voda("Вода");

  final String nameOfGroup;

  const GroupCallsigns(this.nameOfGroup);

  static GroupCallsigns? fromString(String name) {
    final lower = name.toLowerCase();
    try {
      return GroupCallsigns.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == lower ||
            e.nameOfGroup.toLowerCase() == lower,
      );
    } catch (_) {
      return null;
    }
  }

  String getGroupCallsignAsString() {
    return nameOfGroup;
  }
}
