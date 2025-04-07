import 'package:flutter/material.dart';
import 'package:la_registration/data/group.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
import 'package:la_registration/listeners/on_click_group_options_menu.dart';
import 'package:la_registration/listeners/on_group_click_listener.dart';
import 'package:la_registration/listeners/on_volunteer_phone_number_click_listener.dart';

class GroupsAdapter extends StatelessWidget {
  final List<Group> groups;
  final VolunteersViewModel volunteersViewModel;
  final OnVolunteerPhoneNumberClickListener onVolunteerPhoneNumberClickListener;
  final OnClickGroupOptionsMenu onClickGroupOptionsMenu;
  final OnGroupClickListener onGroupClickListener;

  const GroupsAdapter({
    super.key,
    required this.groups,
    required this.volunteersViewModel,
    required this.onVolunteerPhoneNumberClickListener,
    required this.onClickGroupOptionsMenu,
    required this.onGroupClickListener,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, position) {
        final group = groups[position];
        final callsignOfGroup = group.groupCallsign.getGroupCallsignAsString();
        final numberOfGroup = "$callsignOfGroup ${group.numberOfGroup}";

        return Card(
          child: ListTile(
            title: Text(numberOfGroup),
            subtitle: Text(group.dateOfCreation),
            onTap: () {
              onGroupClickListener.onGroupClick(position);
            },
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'options') {
                  onClickGroupOptionsMenu.onGroupOptionsMenuClick(
                    Text(numberOfGroup),
                    group,
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'options',
                  child: Text("Options"),
                ),
              ],
            ),
            onLongPress: () {},
          ),
        );
      },
    );
  }
}
