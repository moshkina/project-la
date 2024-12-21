import 'package:flutter/material.dart';
import 'package:la_registration/data/group.dart'; // Импортируем класс Group
import 'package:la_registration/data/volunteers_viewmodel.dart'; // Импортируем VolunteersViewModel (если нужно в коде)
import 'package:la_registration/listeners/on_click_group_options_menu.dart'; // Импортируем слушатель нажатия на меню
import 'package:la_registration/listeners/on_group_click_listener.dart'; // Импортируем слушатель нажатия на группу
import 'package:la_registration/listeners/on_volunteer_phone_number_click_listener.dart'; // Импортируем слушатель нажатия на номер телефона волонтера

class GroupsAdapter extends StatelessWidget {
  final List<Group> groups; // Список групп
  final VolunteersViewModel volunteersViewModel; // Модель данных для волонтеров
  final OnVolunteerPhoneNumberClickListener
      onVolunteerPhoneNumberClickListener; // Слушатель нажатия на номер телефона волонтера
  final OnClickGroupOptionsMenu
      onClickGroupOptionsMenu; // Слушатель нажатия на меню группы
  final OnGroupClickListener
      onGroupClickListener; // Слушатель нажатия на группу

  const GroupsAdapter({
    super.key, // Добавлен ключ, обязательный для публичных виджетов
    required this.groups, // Обязательный параметр для списка групп
    required this.volunteersViewModel, // Обязательный параметр для модели волонтеров
    required this.onVolunteerPhoneNumberClickListener, // Обязательный параметр для слушателя номера телефона
    required this.onClickGroupOptionsMenu, // Обязательный параметр для слушателя меню
    required this.onGroupClickListener, // Обязательный параметр для слушателя клика по группе
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length, // Количество элементов в списке
      itemBuilder: (context, position) {
        final group = groups[position]; // Получаем группу по индексу
        final callsignOfGroup = group.groupCallsign.getGroupCallsignAsString();
        final numberOfGroup =
            "$callsignOfGroup ${group.numberOfGroup}"; // Формируем строку с номером группы

        return Card(
          child: ListTile(
            title: Text(numberOfGroup), // Заголовок с номером группы
            subtitle: Text(
                group.dateOfCreation), // Подзаголовок с датой создания группы
            onTap: () {
              onGroupClickListener
                  .onGroupClick(position); // Слушатель на клик по группе
            },
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'options') {
                  onClickGroupOptionsMenu.onGroupOptionsMenuClick(
                      Text(numberOfGroup),
                      group); // Слушатель на выбор опций в меню
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'options',
                  child: Text("Options"), // Элемент меню "Options"
                ),
              ],
            ),
            onLongPress: () {
              onVolunteerPhoneNumberClickListener.onVolunteerPhoneNumberClick(group
                  .elderPhoneNumber); // Слушатель на долгий клик по номеру телефона волонтера
            },
          ),
        );
      },
    );
  }
}
