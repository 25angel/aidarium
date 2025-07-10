import 'package:flutter/material.dart';

class PersonalDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Личные данные'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white, // Белый фон для экрана

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(title: Text('Рост: Не определено')),
            ListTile(title: Text('Вес: Не определено')),
            ListTile(title: Text('Пол: Мужской')),
            ListTile(title: Text('Возраст: (30)')),
            ListTile(title: Text('Страна: Казахстан')),
            ListTile(title: Text('Город: Не определено')),
            ListTile(title: Text('Язык: Русский')),
          ],
        ),
      ),
    );
  }
}
