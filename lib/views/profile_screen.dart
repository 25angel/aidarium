import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Для работы с Firestore

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  String _gender = 'Мужской'; // Значение по умолчанию
  String _language = 'Русский'; // Значение по умолчанию
  TextEditingController _ageController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  List<String> _genders = ['Мужской', 'Женский']; // Список для выбора пола
  List<String> _languages = [
    'Русский',
    'Английский',
  ]; // Список для выбора языка
  List<String> _countries = [
    'Казахстан',
    'Россия',
    'США',
  ]; // Пример списка стран

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .get();

    if (userDoc.exists) {
      _heightController.text = userDoc['height'] ?? 'Не определено';
      _weightController.text = userDoc['weight'] ?? 'Не определено';
      _gender = userDoc['gender'] ?? 'Мужской';
      _ageController.text = userDoc['age'] ?? '30';
      _countryController.text = userDoc['country'] ?? 'Казахстан';
      _cityController.text = userDoc['city'] ?? 'Не определено';
      _language = userDoc['language'] ?? 'Русский';
    } else {
      _heightController.text = 'Не определено';
      _weightController.text = 'Не определено';
      _gender = 'Мужской';
      _ageController.text = '30';
      _countryController.text = 'Казахстан';
      _cityController.text = 'Не определено';
      _language = 'Русский';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .set({
            'height': 'Не определено',
            'weight': 'Не определено',
            'gender': 'Мужской',
            'age': '30',
            'country': 'Казахстан',
            'city': 'Не определено',
            'language': 'Русский',
          });
    }
  }

  _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .set({
            'height': _heightController.text,
            'weight': _weightController.text,
            'gender': _gender,
            'age': _ageController.text,
            'country': _countryController.text,
            'city': _cityController.text,
            'language': _language,
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Данные сохранены!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваша медкарта'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Действия при нажатии на иконку настроек
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Профиль пользователя
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    widget.user.photoURL ??
                        'https://www.w3schools.com/w3images/avatar2.png',
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.displayName ?? 'Undefined',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.user.email ?? 'Email not available',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),

            // Форма для редактирования данных
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Рост', _heightController),
                  _buildTextField('Вес', _weightController),
                  _buildDropdownField('Пол', _genders, _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }),
                  _buildTextField('Возраст', _ageController),
                  _buildDropdownField(
                    'Страна',
                    _countries,
                    _countryController.text,
                    (value) {
                      setState(() {
                        _countryController.text = value!;
                      });
                    },
                  ),
                  _buildTextField('Город', _cityController),
                  _buildDropdownField('Язык', _languages, _language, (value) {
                    setState(() {
                      _language = value!;
                    });
                  }),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveUserData,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor:
                          Colors
                              .purple, // Используем backgroundColor вместо primary
                    ),
                    child: Text(
                      'Сохранить данные',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Это поле обязательно для заполнения';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    // Убедитесь, что selectedValue соответствует значению в items
    if (!items.contains(selectedValue)) {
      selectedValue =
          items[0]; // Если selectedValue не в списке, установите первое значение
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items:
            items.map((item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: (value) {
          setState(() {
            // Обновляем значение при выборе
            onChanged(value);
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Выберите $label';
          }
          return null;
        },
      ),
    );
  }
}
