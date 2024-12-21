import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';

class VolunteerAutoCompleteAdapter extends StatelessWidget {
  final List<Volunteer> volunteers;
  final TextEditingController controller;

  const VolunteerAutoCompleteAdapter({
    super.key,
    required this.volunteers,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Volunteer>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return volunteers.where((volunteer) =>
            volunteer.fullName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()) ||
            volunteer.callSign
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (Volunteer option) => option.fullName,
      onSelected: (Volunteer selection) {
        controller.text = selection.fullName;
      },
    );
  }
}
