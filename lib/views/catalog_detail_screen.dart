import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Импорт Firebase Auth

class CatalogDetailScreen extends StatelessWidget {
  final String itemId;

  CatalogDetailScreen({required this.itemId});

  Future<void> placeOrder(BuildContext context, DocumentSnapshot item) async {
    try {
      // Получаем текущего пользователя через Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Если пользователь не авторизован, выводим ошибку
      if (currentUser == null) {
        throw 'Пользователь не авторизован';
      }

      // Получаем userId из текущего пользователя
      String userId = currentUser.uid;

      // Получаем ID документа товара
      String itemId = item.id;

      // Создаем заказ
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': userId, // Используем userId текущего пользователя
        'itemId':
            itemId, // Используем ID документа Firestore как идентификатор товара
        'name': item['name'],
        'price': item['price'],
        'imageURL': item['imageURL'],
        'orderDate': FieldValue.serverTimestamp(),
      });

      // Отображаем сообщение об успешном заказе
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ваш заказ успешно оформлен!')));

      // После оформления заказа можно выполнить переход на другой экран или вернуться назад
      // Например, возвращаемся на предыдущий экран
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка при оформлении заказа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Фон экрана белый
      appBar: AppBar(
        title: Text('Детали товара'),
        backgroundColor: const Color.fromARGB(
          255,
          186,
          170,
          230,
        ), // Цвет AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('catalogitems')
                .doc(itemId)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Товар не найден',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          var item = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Контейнер для прокручиваемого контента
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Изображение товара с эффектом тени
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                item['imageURL'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Название товара
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Описание товара с HTML разметкой
                        Html(
                          data: item['description'],
                          style: {
                            "p": Style(
                              fontSize: FontSize.medium,
                              color: Colors.black87,
                            ),
                            "strong": Style(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurpleAccent,
                            ),
                          },
                        ),
                        SizedBox(height: 20),

                        // Цена товара
                        Text(
                          '${item['price']} ₸',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Кнопка оформления заказа с фиксированным положением внизу
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed:
                        () => placeOrder(
                          context,
                          item,
                        ), // Вызов функции оформления заказа
                    child: Text('Заказать', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        189,
                        170,
                        244,
                      ), // Цвет кнопки
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
