import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/data/groups_viewmodel.dart';
import 'package:la_registration/data/volunteers_viewmodel.dart';
import 'package:la_registration/listeners/on_volunteer_click_listener.dart';
import 'package:la_registration/listeners/on_volunteer_phone_number_click_listener.dart';
import 'package:la_registration/util/time_picker_dialog.dart'; // Your time picker

class VolunteerAdapter extends StatelessWidget {
  final List<Volunteer> volunteers;
  final VolunteersViewModel viewModel;
  final GroupsViewModel groupsViewModel;
  final OnVolunteerPhoneNumberClickListener onVolunteerPhoneNumberClickListener;
  final OnVolunteerClickListener onVolunteerClickListener;

  const VolunteerAdapter({
    super.key,
    required this.volunteers,
    required this.viewModel,
    required this.groupsViewModel,
    required this.onVolunteerPhoneNumberClickListener,
    required this.onVolunteerClickListener,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: volunteers.length,
      itemBuilder: (context, position) {
        final volunteer = volunteers[position];
        String groupName = "";

        // Handle async fetching group info
        if (volunteer.groupId != null) {
          // Assuming groupsViewModel.getGroupById() is async
          groupsViewModel.getGroupById(volunteer.groupId!).then((group) {
            if (group != null) {
              groupName = "${group.groupCallsign} ${group.numberOfGroup}";
            }
          });
        }

        return Card(
          child: ListTile(
            title: Text(volunteer.fullName),
            subtitle: Text(groupName),
            onTap: () {
              onVolunteerClickListener.onVolunteerClick(position);
            },
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                onVolunteerPhoneNumberClickListener
                    .onVolunteerPhoneNumberClick(volunteer.phoneNumber);
              },
            ),
            onLongPress: () {
              _showPopup(context, volunteer, position);
            },
          ),
        );
      },
    );
  }

  void _showPopup(BuildContext context, Volunteer volunteer, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: const Text('Change Status'),
              onTap: () {
                _changeStatus(context, volunteer, position);
              },
            ),
            ListTile(
              title: const Text('Set Time'),
              onTap: () {
                _setTime(context, volunteer, position);
              },
            ),
            ListTile(
              title: const Text('Edit Data'),
              onTap: () {
                onVolunteerClickListener.onVolunteerClick(position);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeStatus(BuildContext context, Volunteer volunteer, int position) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Active'),
                onTap: () {
                  volunteer.status = 'Active';
                  viewModel.updateVolunteer(volunteer);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Left'),
                onTap: () {
                  volunteer.status = 'Left';
                  viewModel.updateVolunteer(volunteer);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setTime(BuildContext context, Volunteer volunteer, int position) {
    showTimePickerDialog(
      context,
      (time) {
        final formattedTime =
            '${time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
        volunteer.timeForSearch = formattedTime;
        viewModel.updateVolunteer(volunteer);
      },
    );
  }
}
