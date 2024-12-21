import 'package:flutter/material.dart';
import 'package:la_registration/data/volunteer.dart';

class VolunteerDetailScreen extends StatelessWidget {
  final Volunteer volunteer;

  const VolunteerDetailScreen({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(volunteer.fullName), // Используем существующее поле fullName
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name: ${volunteer.fullName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone Number: ${volunteer.phoneNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Call Sign: ${volunteer.callSign.isNotEmpty ? volunteer.callSign : "Not specified"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Nickname: ${volunteer.nickName.isNotEmpty ? volunteer.nickName : "Not specified"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Region: ${volunteer.region.isNotEmpty ? volunteer.region : "Not specified"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Car: ${volunteer.car.isNotEmpty ? volunteer.car : "Not specified"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${volunteer.status}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Additional Info:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Group Size: ${volunteer.index}', // Заменили size на index
              style: const TextStyle(fontSize: 16),
            ),
            // Если необходимо, вы можете также добавить другие новые поля:
            const SizedBox(height: 8),
            Text(
              'Sent Status: ${volunteer.isSent}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Notify That Left: ${volunteer.notifyThatLeft}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Time for Search: ${volunteer.timeForSearch.isNotEmpty ? volunteer.timeForSearch : "Not specified"}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
