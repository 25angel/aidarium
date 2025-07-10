import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Импортируем Firebase
import '/views/login_screen.dart'; // Экран входа
import '/views/main_screen.dart'; // Экран главной страницы
import 'package:firebase_auth/firebase_auth.dart'; // Импортируем Firebase Auth

void main() async {
  // Убедимся, что Flutter инициализируется перед Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Firebase
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Проверяем, авторизован ли пользователь
    return MaterialApp(
      title: 'Flutter Firebase Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Если пользователь не авторизован, показываем экран входа
      // Если авторизован, показываем главную страницу
      home:
          FirebaseAuth.instance.currentUser == null
              ? LoginScreen()
              : HomeScreen(),
    );
  }
}
