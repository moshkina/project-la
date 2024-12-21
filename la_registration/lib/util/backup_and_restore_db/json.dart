// Класс Json для работы с JSON-данными
class Json {
  final Map<String, dynamic> jsonObject;

  Json._(this.jsonObject);

  // Строитель для удобного создания объекта Json
  static Builder builder() {
    return Builder();
  }
}

// Строитель для создания объекта Json
class Builder {
  final Map<String, dynamic> _object = {};

  // Метод для добавления строки в JSON-объект
  Builder putItem(String? key, String? value) {
    if (key != null && value != null) {
      _object[key] = value;
    }
    return this;
  }

  // Метод для добавления списка объектов Json в JSON-объект
  Builder putItemList(String? key, List<Json> items) {
    if (key != null) {
      _object[key] = items.map((item) => item.jsonObject).toList();
    }
    return this;
  }

  // Метод для создания объекта Json из Builder
  Json build() {
    return Json._(_object);
  }
}
