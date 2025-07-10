import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart'; // Для HTML-разметки

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String photoUrl;

  ArticleDetailScreen({
    required this.title,
    required this.description,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Оборачиваем всё в SingleChildScrollView для прокрутки
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Выравнивание текста влево
          children: [
            Image.network(photoUrl),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Html(
              data: description,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  color: Colors.black87,
                  lineHeight: LineHeight.number(
                    1.5,
                  ), // Добавляем высоту строки для удобства чтения
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
