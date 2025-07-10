import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Для функциональности звонка
import 'clinics_detail_screen.dart'; // Импортируем экран подробностей клиники

class ClinicsScreen extends StatefulWidget {
  @override
  _ClinicsScreenState createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Клиники',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Здесь можно добавить функциональность поиска
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _firestore.collection('clinics').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Нет доступных клиник',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          var clinics = snapshot.data!.docs;
          return ListView.builder(
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              var clinic = clinics[index];
              return GestureDetector(
                onTap: () {
                  // Переход на экран подробностей клиники
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ClinicDetailScreen(
                            clinicId: clinic.id,
                            name: clinic['name'],
                            location: clinic['location'],
                            rating: clinic['rating'].toDouble(),
                            logoUrl: clinic['logoUrl'],
                            services: clinic['services'],
                            contactEmail: clinic['contactEmail'],
                            contactSite: clinic['contactSite'],
                            description: clinic['description'],
                            mobilePhone:
                                clinic['mobilePhone'], // Здесь номер телефона
                          ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            clinic['logoUrl'],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clinic['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                clinic['location'],
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    clinic['rating'].toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Кнопка звонка
                        IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.green,
                            size: 30,
                          ),
                          onPressed: () {
                            _makePhoneCall(
                              clinic['mobilePhone'],
                            ); // Передаем номер телефона из Firebase
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Функция для совершения звонка
  void _makePhoneCall(String phoneNumber) async {
    // Очищаем номер телефона от символов, не относящихся к номеру (например, пробелы, дефисы, скобки)
    String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Проверяем, начинается ли номер с плюса
    if (!formattedNumber.startsWith('+')) {
      formattedNumber = '+$formattedNumber'; // Добавляем плюс в начало номера
    }

    final Uri url = Uri.parse('tel:$formattedNumber');

    // Пытаемся вызвать номер
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Не удалось совершить звонок на $phoneNumber';
    }
  }
}
