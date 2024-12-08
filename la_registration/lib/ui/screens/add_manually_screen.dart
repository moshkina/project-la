import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/listeners/volunteers_viewmodel.dart';

class AddManuallyScreen extends StatefulWidget {
  final int volunteerId;
  final int size;

  const AddManuallyScreen(
      {super.key, required this.volunteerId, required this.size});

  @override
  AddManuallyScreenState createState() => AddManuallyScreenState();
}

class AddManuallyScreenState extends State<AddManuallyScreen> {
  late VolunteersViewModel _viewModel;
  late TextEditingController fullNameController;
  late TextEditingController callSignController;
  late TextEditingController forumNicknameController;
  late TextEditingController regionController;
  late TextEditingController phoneNumberController;
  late TextEditingController carController;
  late Volunteer volunteer;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    _viewModel = VolunteersViewModel();
    fullNameController = TextEditingController();
    callSignController = TextEditingController();
    forumNicknameController = TextEditingController();
    regionController = TextEditingController();
    phoneNumberController = TextEditingController();
    carController = TextEditingController();

    if (widget.volunteerId != 0) {
      _viewModel.getVolunteerById(widget.volunteerId).then((vol) {
        setState(() {
          volunteer = vol;
          fullNameController.text = volunteer.fullName;
          callSignController.text = volunteer.callSign;
          forumNicknameController.text = volunteer.nickName;
          regionController.text = volunteer.region;
          phoneNumberController.text = volunteer.phoneNumber;
          carController.text = volunteer.car;
          isEdited = true;
        });
      });
    }
  }

  void _saveData() {
    String fullName = fullNameController.text.trim();
    String callSign = callSignController.text.trim();
    String nickName = forumNicknameController.text.trim();
    String region = regionController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String car = carController.text.trim();

    if (fullName.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in the required fields.")));
    } else if (isEdited) {
      volunteer = Volunteer(
        uniqueId: volunteer.uniqueId, // Keep the existing uniqueId
        fullName: fullName,
        phoneNumber: phoneNumber,
        callSign: callSign,
        nickName: nickName,
        region: region,
        car: car,
        status: volunteer.status,
        size: volunteer.size,
      );
      _viewModel.updateVolunteer(volunteer);
      Navigator.pop(context);
    } else {
      Volunteer newVolunteer = Volunteer(
        uniqueId: 0,
        size: widget.size,
        fullName: fullName,
        phoneNumber: phoneNumber,
        callSign: callSign,
        nickName: nickName,
        region: region,
        car: car,
        status: "Active",
      );
      _viewModel.insertVolunteer(newVolunteer);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Manually')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: "Full Name")),
            TextField(
                controller: callSignController,
                decoration: const InputDecoration(labelText: "Call Sign")),
            TextField(
                controller: forumNicknameController,
                decoration: const InputDecoration(labelText: "Forum Nickname")),
            TextField(
                controller: regionController,
                decoration: const InputDecoration(labelText: "Region")),
            TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: "Phone Number")),
            TextField(
                controller: carController,
                decoration: const InputDecoration(labelText: "Car")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text(isEdited ? 'Save Changes' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
