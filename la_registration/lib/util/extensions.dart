import 'package:flutter/material.dart';

enum GroupCallsigns {
  lisa,
  bort,
  kinolog,
  veter,
  voda,
  pegas,
  autonome,
  police,
  mchs,
  pso
}

extension GroupCallsignExtension on GroupCallsigns {
  String getGroupCallsignAsString(BuildContext context) {
    switch (this) {
      case GroupCallsigns.lisa:
        return 'Лиса';
      case GroupCallsigns.bort:
        return 'Борт';
      case GroupCallsigns.kinolog:
        return 'Кинолог';
      case GroupCallsigns.veter:
        return 'Ветер';
      case GroupCallsigns.voda:
        return 'Вода';
      case GroupCallsigns.pegas:
        return 'Пегас';
      case GroupCallsigns.autonome:
        return 'Автоном';
      case GroupCallsigns.police:
        return 'Полиция';
      case GroupCallsigns.mchs:
        return 'МЧС';
      default:
        return 'ПСО';
    }
  }
}
