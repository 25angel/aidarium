import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'catalog_detail_screen.dart';

class CatalogScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Белый фон для экрана
      appBar: AppBar(
        title: Text(
          'Каталог',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(
          255,
          175,
          147,
          250,
        ), // Цвет AppBar (схожий с другими экранами)
        elevation: 4, // Легкая тень для AppBar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('catalogitems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Нет доступных товаров'));
          }

          var items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return _buildCatalogItem(
                context,
                item.id,
                item['name'],
                item['price'].toString(),
                item['imageURL'],
                item['description'], // Используем описание с HTML-разметкой
                item['sortitem'],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCatalogItem(
    BuildContext context,
    String itemId,
    String title,
    String price,
    String imageUrl,
    String description,
    String category,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Контент товара
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название товара
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // Цена товара
                  Text(
                    '$price ₸',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Категория товара
                  Text(
                    category,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  // Кнопка перехода на страницу товара
                  ElevatedButton(
                    onPressed: () {
                      // Переход на экран с деталями товара
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CatalogDetailScreen(itemId: itemId),
                        ),
                      );
                    },
                    child: Text(
                      'Подробнее',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        175,
                        147,
                        250,
                      ), // Цвет кнопки (согласованный с остальными экранами)
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
}
