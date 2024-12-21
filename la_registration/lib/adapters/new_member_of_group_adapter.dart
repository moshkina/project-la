import 'package:flutter/material.dart';
import 'package:la_registration/adapters/volunteer_auto_complete_adapter.dart';
import 'package:la_registration/listeners/on_click_delete_new_member_of_group_listener.dart';
import 'package:la_registration/listeners/on_volunteer_item_click_listener.dart';

class NewMemberOfGroupAdapter extends StatefulWidget {
  final VolunteerAutoCompleteAdapter adapter;
  final List<String> newMembers;
  final OnClickDeleteNewMemberOfGroupListener onClickDeleteMemberListener;
  final OnVolunteerItemClickListener onVolunteerItemClickListener;

  const NewMemberOfGroupAdapter({
    super.key,
    required this.adapter,
    required this.newMembers,
    required this.onClickDeleteMemberListener,
    required this.onVolunteerItemClickListener,
  });

  @override
  NewMemberOfGroupAdapterState createState() => NewMemberOfGroupAdapterState();
}

class NewMemberOfGroupAdapterState extends State<NewMemberOfGroupAdapter> {
  bool isTyping = false;

  void addMember(String text) {
    setState(() {
      widget.newMembers.add(text);
    });
  }

  void deleteMember(int position) {
    setState(() {
      widget.newMembers.removeAt(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.newMembers.length,
      itemBuilder: (context, position) {
        final member = widget.newMembers[position];
        return ListTile(
          title: Text(member),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onClickDeleteMemberListener.onClickDeleteMember(position);
            },
          ),
          onTap: () {
            widget.onVolunteerItemClickListener.onVolunteerItemClick(position);
          },
        );
      },
    );
  }
}
