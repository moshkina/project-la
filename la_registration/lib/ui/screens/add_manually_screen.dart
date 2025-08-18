import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/data/volunteers_dao.dart';
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

    fullNameController.addListener(_checkForDuplicate);
    phoneNumberController.addListener(_checkForDuplicate);

    if (widget.volunteerId != 0) {
      _viewModel.getVolunteerById(widget.volunteerId).then((vol) {
        setState(() {
          volunteer = vol!;
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

    // Совпадения по имени
    final nameMatches = name.isNotEmpty
        ? volunteers
            .where((v) => v.fullName.toLowerCase() == name.toLowerCase())
            .toList()
        : [];

    // Совпадения по телефону
    final phoneMatches = phone.isNotEmpty
        ? volunteers.where((v) => v.phoneNumber == phone).toList()
        : [];

    setState(() {
      _isNameDuplicate = nameMatches.isNotEmpty;
      _isPhoneDuplicate = phoneMatches.isNotEmpty;

      if (_isNameDuplicate && _isPhoneDuplicate) {
        // Проверяем, совпадает ли и имя, и телефон у одного и того же волонтёра
        final samePerson = volunteers.any((v) =>
            v.fullName.toLowerCase() == name.toLowerCase() &&
            v.phoneNumber == phone);

        if (samePerson) {
          _duplicateMessage = 'Этот человек вероятно уже внесён';
        } else {
          // разные люди
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

  void _saveData() {
    String fullName = fullNameController.text.trim();
    String callSign = callSignController.text.trim();
    String nickName = forumNicknameController.text.trim();
    String region = regionController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String car = carController.text.trim();

    if (fullName.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Пожалуйста, заполните обязательные поля.")));
      return;
    }

    // // ⚡ Больше не блокируем сохранение, просто предупреждаем
    // if ((_isNameDuplicate || _isPhoneDuplicate) && !isEdited) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("⚠ $_duplicateMessage\nВсё равно сохраняем."),
    //     duration: const Duration(seconds: 3),
    //   ));
    // }

    if (isEdited) {
      print('[DEBUG] Обновление волонтера ID: ${volunteer.uniqueId}');
      volunteer = Volunteer(
          uniqueId: volunteer.uniqueId,
          index: volunteer.index,
          fullName: fullName,
          phoneNumber: phoneNumber,
          callSign: callSign,
          nickName: nickName,
          region: region,
          car: car,
          status: volunteer.status,
          notifyThatLeft: volunteer.notifyThatLeft,
          timeForSearch: volunteer.timeForSearch,
          groupId: volunteer.groupId);
      _viewModel.updateVolunteer(volunteer).then((_) {
        print('[DEBUG] Волонтер успешно обновлен');
        Navigator.pop(context);
      }).catchError((e) {
        print('[ERROR] Ошибка обновления: $e');
      });
    } else {
      print('[DEBUG] Создание нового волонтера');
      Volunteer newVolunteer = Volunteer(
          index: 0,
          fullName: fullName,
          phoneNumber: phoneNumber,
          callSign: callSign,
          nickName: nickName,
          region: region,
          car: car,
          status: "Активный",
          notifyThatLeft: "false",
          timeForSearch: "",
          groupId: null);
      _viewModel.insertVolunteer(newVolunteer).then((_) {
        print('[DEBUG] Новый волонтер успешно сохранен');
        Navigator.pop(context);
      }).catchError((e) {
        print('[ERROR] Ошибка сохранения: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить вручную',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF96800),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Полное имя*",
                labelStyle: TextStyle(color: Colors.white),
                hintText: "Введите полное имя",
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
            // Остальные поля остаются без изменений
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
            TextField(
              controller: carController,
              decoration: const InputDecoration(
                labelText: "Машина",
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
            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}
