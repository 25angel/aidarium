import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart'; // Импортируем для работы с HTML

class HairResultScreen extends StatelessWidget {
  final String result;
  final String diagnosis;
  final String imagePath;

  const HairResultScreen({
    Key? key,
    required this.result,
    required this.diagnosis,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результат анализа'),
        backgroundColor: Color(0xFF41C3FF),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото
            Image.file(
              File(imagePath),
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Результат анализа
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Рекомендации:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Html(
                    data: diagnosis,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16),
                        color: Colors.black87,
                        textAlign: TextAlign.left,
                      ),
                      "li": Style(margin: Margins(bottom: Margin(8))),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName(Navigator.defaultRouteName),
            );
          },
          child: Text('На главную'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF41C3FF),
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
