import 'package:flutter/material.dart';
import 'package:iaidarium/views/consultation_screen.dart';
import 'hair_test_screen.dart';
import 'analysis_decoding_screen.dart';
import 'hair_photo_screen.dart'; // Подключаем новый экран для фото
import 'compatibility_check_screen.dart'; // Подключаем экран для проверки совместимости продуктов

class ServiceScreen extends StatelessWidget {
  final List<Service> services = [
    Service(
      'Анализ волос и кожи головы (по тесту)',
      'assets/robot_icon.png',
      const Color.fromARGB(255, 255, 255, 255),
      (BuildContext context) => TestScreen(),
    ),
    Service(
      'Расшифровка результатов анализов',
      'assets/result_icon.png',
      const Color.fromARGB(255, 255, 255, 255),
      (BuildContext context) => AnalysisDecodingScreen(),
    ),
    Service(
      'Анализ волос и кожи головы (по фото)',
      'assets/hair_analyse.png', // Новый иконка для загрузки фото
      const Color.fromARGB(255, 255, 255, 255),
      (BuildContext context) =>
          HairPhotoScreen(), // Новый экран для загрузки фото
    ),
    Service(
      'Проверка средств на совместимость',
      'assets/shampoo_icon.png', // Иконка для проверки совместимости
      const Color.fromARGB(255, 255, 255, 255),
      (BuildContext context) =>
          CompatibilityCheckScreen(), // Новый экран для проверки совместимости
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCard(service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final String imagePath;
  final Color color;
  final Widget Function(BuildContext) screen;

  Service(this.title, this.imagePath, this.color, this.screen);
}

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard(this.service);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: service.screen),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      service.imagePath,
                      width: 150,
                      height: 100,
                    ), // Уменьшаем иконку
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          service.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
