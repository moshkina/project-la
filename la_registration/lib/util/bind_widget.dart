import 'package:flutter/widgets.dart';

class WidgetBinding<T extends Widget> {
  final GlobalKey key = GlobalKey();
  T get widget => key.currentWidget as T;
}

WidgetBinding<T> bindWidget<T extends Widget>() {
  return WidgetBinding<T>();
}
