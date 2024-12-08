import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_registration/listeners/counter_viewmodel.dart'; // Импортируем ViewModel

class CounterScreen extends StatelessWidget {
  // Добавляем параметр key в конструктор
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App with ViewModel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Слушаем изменения в CounterViewModel
            Consumer<CounterViewModel>(
              builder: (context, counter, child) {
                return Text(
                  'Count: ${counter.count}', // Отображаем текущее значение счетчика
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Вызываем метод для увеличения счетчика
                context.read<CounterViewModel>().increment();
              },
              child: const Text('Increment'),
            ),
            ElevatedButton(
              onPressed: () {
                // Вызываем метод для уменьшения счетчика
                context.read<CounterViewModel>().decrement();
              },
              child: const Text('Decrement'),
            ),
            ElevatedButton(
              onPressed: () {
                // Вызываем метод для сброса счетчика
                context.read<CounterViewModel>().reset();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
