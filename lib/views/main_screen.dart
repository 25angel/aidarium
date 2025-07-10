import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iaidarium/views/consultation_screen.dart';
import 'article_detail_screen.dart';
import 'service_screen.dart';
import 'clinics_screen.dart';
import 'tasks_screen.dart';
import 'catalog_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Экспресс-экран для каждой вкладки
  final List<Widget> _screens = [
    ServiceScreen(), // Экран с сервисами
    ClinicsScreen(),
    TasksScreen(),
    ConsultationScreen(),
    CatalogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _currentIndex == 0
              ? AppBar(
                title: Text(
                  'Главная',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white, // Белый фон для AppBar
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.black),
                    onPressed: () {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(user: user),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please log in first')),
                        );
                      }
                    },
                  ),
                ],
              )
              : null,
      body: Container(
        color: Colors.white, // Белый фон для всего контента
        child: Column(
          children: [
            Expanded(
              child: _screens[_currentIndex], // Экран вкладки
            ),
            // Раздел с Articles только для главного экрана
            if (_currentIndex == 0) ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Полезные статьи',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    StreamBuilder(
                      stream: _firestore.collection('articles').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('Нет доступных статей'));
                        }

                        var articles = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            var article = articles[index];
                            return GestureDetector(
                              onTap: () {
                                // Переход на экран с деталями статьи
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ArticleDetailScreen(
                                          title: article['title'],
                                          description: article['description'],
                                          photoUrl: article['photoUrl'],
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white, // Белый фон для карточки
                                elevation: 5,
                                margin: EdgeInsets.symmetric(vertical: 8),
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
                                          article['photoUrl'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article['title'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Нажмите, чтобы прочитать...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Белый фон для нижней панели
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // Обновление текущего индекса при выборе вкладки
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Клиники',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Задачи'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Консультация',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Каталог',
          ),
        ],
      ),
    );
  }
}
