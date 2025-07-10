import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart'; // Для HTML-разметки

class ClinicDetailScreen extends StatelessWidget {
  final String clinicId;
  final String name;
  final String location;
  final double rating;
  final String logoUrl;
  final String contactEmail;
  final String contactSite;
  final String mobilePhone;
  final String description; // Описание клиники
  final List<dynamic> services; // Список сервисов

  ClinicDetailScreen({
    required this.clinicId,
    required this.name,
    required this.location,
    required this.rating,
    required this.logoUrl,
    required this.contactEmail,
    required this.contactSite,
    required this.mobilePhone,
    required this.description,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blueAccent, // Новый цвет для AppBar
        elevation: 4, // Немного тени для лучшего восприятия
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Логотип клиники
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                logoUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Название клиники
            Text(
              name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),

            // Местоположение клиники
            Text('Местоположение: $location', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),

            // Рейтинг клиники
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 24),
                SizedBox(width: 4),
                Text(
                  'Рейтинг: ${rating.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Блок с услугами
            Text(
              'Услуги клиники:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            _buildServicesList(services), // Отображаем список услуг
            SizedBox(height: 16),

            // Описание клиники
            Text(
              'О клинике:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Html(
              data: description, // Описание из Firestore (HTML)
            ),
            SizedBox(height: 16),

            // Контактная информация
            Text(
              'Контакты:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            _buildContactRow(Icons.email, contactEmail),
            _buildContactRow(Icons.link, contactSite, isLink: true),
            _buildContactRow(Icons.phone, mobilePhone),
          ],
        ),
      ),
    );
  }

  // Метод для отображения списка сервисов
  Widget _buildServicesList(List<dynamic> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          services
              .map(
                (service) => GestureDetector(
                  onTap: () {
                    // Добавьте функциональность при клике на услугу, если нужно
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.medical_services,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 16),
                          Text(
                            service,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  // Метод для отображения контактной информации
  Widget _buildContactRow(IconData icon, String text, {bool isLink = false}) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (isLink) {
                _launchURL(text);
              } else {
                // Добавить функционал для почты, когда решите
              }
            },
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isLink ? Colors.blue : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  // Функция для открытия URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Не удалось открыть ссылку: $url';
    }
  }
}
