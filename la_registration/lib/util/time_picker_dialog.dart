import 'package:flutter/material.dart';

Future<void> showTimePickerDialog(
    BuildContext context, Function(TimeOfDay) onTimePicked) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    onTimePicked(picked);
  }
}
