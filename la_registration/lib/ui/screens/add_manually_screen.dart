import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';

class AddManuallyScreen extends StatefulWidget {
  final int volunteerId;
  final String size;

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
  late TextEditingController additionalInfoController;
  late Volunteer volunteer;
  bool isEdited = false;
  bool _isNameDuplicate = false;
  bool _isPhoneDuplicate = false;
  String _duplicateMessage = '';

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<VolunteersViewModel>(context, listen: false);

    fullNameController = TextEditingController();
    callSignController = TextEditingController();
    forumNicknameController = TextEditingController();
    regionController = TextEditingController();
    phoneNumberController = TextEditingController();
    carController = TextEditingController();
    additionalInfoController = TextEditingController();

    fullNameController.addListener(_checkForDuplicate);
    phoneNumberController.addListener(_checkForDuplicate);

    if (widget.volunteerId != 0) {
      _loadVolunteerData();
    }
  }

  Future<void> _loadVolunteerData() async {
    try {
      final volunteerData =
          await _viewModel.getVolunteerById(widget.volunteerId);
      if (volunteerData != null && mounted) {
        setState(() {
          volunteer = volunteerData;
          fullNameController.text = volunteer.fullName;
          callSignController.text = volunteer.callSign;
          forumNicknameController.text = volunteer.nickName;
          regionController.text = volunteer.region;
          phoneNumberController.text = volunteer.phoneNumber;
          carController.text = volunteer.car;
          additionalInfoController.text = volunteer.additionalInfo;
          isEdited = true;
        });
      }
    } catch (e) {
      debugPrint('Ошибка загрузки данных волонтёра: $e');
    }
  }

  @override
  void dispose() {
    fullNameController.removeListener(_checkForDuplicate);
    phoneNumberController.removeListener(_checkForDuplicate);
    fullNameController.dispose();
    callSignController.dispose();
    forumNicknameController.dispose();
    regionController.dispose();
    phoneNumberController.dispose();
    carController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  void _checkForDuplicate() async {
    final name = fullNameController.text.trim();
    final phone = phoneNumberController.text.trim();

    if (name.isEmpty && phone.isEmpty) {
      setState(() {
        _isNameDuplicate = false;
        _isPhoneDuplicate = false;
        _duplicateMessage = '';
      });
      return;
    }

    final volunteers = await _viewModel.getAllVolunteers();

    final nameMatches = name.isNotEmpty
        ? volunteers
            .where((v) => v.fullName.toLowerCase() == name.toLowerCase())
            .toList()
        : [];

    final phoneMatches = phone.isNotEmpty
        ? volunteers.where((v) => v.phoneNumber == phone).toList()
        : [];

    setState(() {
      _isNameDuplicate = nameMatches.isNotEmpty;
      _isPhoneDuplicate = phoneMatches.isNotEmpty;

      if (_isNameDuplicate && _isPhoneDuplicate) {
        final samePerson = volunteers.any((v) =>
            v.fullName.toLowerCase() == name.toLowerCase() &&
            v.phoneNumber == phone);

        if (samePerson) {
          _duplicateMessage = 'Этот человек вероятно уже внесён';
        } else {
          _duplicateMessage =
              'Имя совпадает с одним человеком, телефон — с другим';
        }
      } else if (_isNameDuplicate) {
        _duplicateMessage = 'Человек с таким именем уже есть в базе';
      } else if (_isPhoneDuplicate) {
        _duplicateMessage = 'Этот номер телефона уже есть в базе';
      } else {
        _duplicateMessage = '';
      }
    });
  }

  void _saveData() async {
    String fullName = fullNameController.text.trim();
    String callSign = callSignController.text.trim();
    String nickName = forumNicknameController.text.trim();
    String region = regionController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String car = carController.text.trim();
    String additionalInfo = additionalInfoController.text.trim();

    if (fullName.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Пожалуйста, заполните обязательные поля.")));
      return;
    }

    try {
      if (isEdited) {
        volunteer = Volunteer(
            uniqueId: volunteer.uniqueId,
            index: volunteer.index,
            fullName: fullName,
            phoneNumber: phoneNumber,
            callSign: callSign,
            nickName: nickName,
            region: region,
            car: car,
            additionalInfo: additionalInfo,
            status: volunteer.status,
            notifyThatLeft: volunteer.notifyThatLeft,
            timeForSearch: volunteer.timeForSearch,
            groupId: volunteer.groupId);
        await _viewModel.updateVolunteer(volunteer);
        Navigator.pop(context);
      } else {
        Volunteer newVolunteer = Volunteer(
            index: 0,
            fullName: fullName,
            phoneNumber: phoneNumber,
            callSign: callSign,
            nickName: nickName,
            region: region,
            car: car,
            additionalInfo: additionalInfo,
            status: "Активный",
            notifyThatLeft: "false",
            timeForSearch: "",
            groupId: null);
        await _viewModel.insertVolunteer(newVolunteer);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Ошибка сохранения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdited ? 'Редактировать волонтёра' : 'Добавить вручную',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF96800),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: "ФИО*",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Введите ФИО",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                if (_isNameDuplicate && fullNameController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      _duplicateMessage,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: "Телефон*",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Введите номер телефона",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                ),
                if (_isPhoneDuplicate && phoneNumberController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      _duplicateMessage,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: callSignController,
                  decoration: const InputDecoration(
                    labelText: "Позывной",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Введите позывной",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: forumNicknameController,
                  decoration: const InputDecoration(
                    labelText: "Ник на форуме",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Введите ник на форуме",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: regionController,
                  decoration: const InputDecoration(
                    labelText: "Регион",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Введите регион",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: carController,
                  decoration: const InputDecoration(
                    labelText: "Авто (гос.номер)",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Введите гос.номер",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: additionalInfoController,
                  decoration: const InputDecoration(
                    labelText: "Дополнительно",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Навыки, ограничения по времени, особенности...",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF96800),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    isEdited ? 'Сохранить изменения' : 'Сохранить',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
