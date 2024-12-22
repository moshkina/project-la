import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';
import 'package:la_registration/listeners/volunteers_viewmodel.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Пожалуйста, заполните обязательные поля.")));
    } else if (isEdited) {
      volunteer = Volunteer(
          uniqueId: volunteer.uniqueId, // Keep the existing uniqueId
          index: volunteer.index, // Передаем индекс
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
      _viewModel.updateVolunteer(volunteer);
      Navigator.pop(context);
    } else {
      Volunteer newVolunteer = Volunteer(
          uniqueId: 0,
          index: 0, // Убедитесь, что _index передается
          fullName: fullName,
          phoneNumber: phoneNumber,
          callSign: callSign,
          nickName: nickName,
          region: region,
          car: car,
          status: "Active",
          notifyThatLeft: "false",
          timeForSearch: "", // Задайте нужные значения по умолчанию
          groupId: null // Если нужно, передайте значение groupId
          );
      _viewModel.insertVolunteer(newVolunteer);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить вручную',
          style: TextStyle(color: Colors.white), // Белый текст
        ),
        backgroundColor: const Color(0xFFF96800), // Оранжевый фон
      ),
      backgroundColor: Colors.black, // Чёрный фон для всего экрана
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Полное имя",
                labelStyle: TextStyle(color: Colors.white), // Белый текст
                hintText: "Введите полное имя",
                hintStyle:
                    TextStyle(color: Colors.grey), // Прозрачные подсказки
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            TextField(
              controller: callSignController,
              decoration: const InputDecoration(
                labelText: "Позывной",
                labelStyle: TextStyle(color: Colors.white), // Белый текст
                hintText: "Введите позывной",
                hintStyle:
                    TextStyle(color: Colors.grey), // Прозрачные подсказки
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            TextField(
              controller: forumNicknameController,
              decoration: const InputDecoration(
                labelText: "Ник на форуме",
                labelStyle: TextStyle(color: Colors.white), // Белый текст
                hintText: "Введите ник на форуме",
                hintStyle:
                    TextStyle(color: Colors.grey), // Прозрачные подсказки
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            TextField(
              controller: regionController,
              decoration: const InputDecoration(
                labelText: "Регион",
                labelStyle: TextStyle(color: Colors.white), // Белый текст
                hintText: "Введите регион",
                hintStyle:
                    TextStyle(color: Colors.grey), // Прозрачные подсказки
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: "Телефон",
                labelStyle: TextStyle(color: Colors.white), // Белый текст
                hintText: "Введите номер телефона",
                hintStyle:
                    TextStyle(color: Colors.grey), // Прозрачные подсказки
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            TextField(
              controller: carController,
              decoration: const InputDecoration(
                labelText: "Машина",
                labelStyle: TextStyle(color: Colors.white), // Белый текст
                hintText: "Введите гос.номер",
                hintStyle:
                    TextStyle(color: Colors.grey), // Прозрачные подсказки
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Белая рамка
                ),
              ),
              style: const TextStyle(color: Colors.white), // Белый текст
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF96800),
              ),
              child: Text(
                isEdited ? 'Сохранить изменения' : 'Сохранить',
                style: const TextStyle(color: Colors.white), // Белый текст
              ),
            ),
          ],
        ),
      ),
    );
  }
}
