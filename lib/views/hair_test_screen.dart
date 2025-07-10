import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'hair_check_screen.dart';
import 'main_screen.dart'; // Экран для перехода или главный экран

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> questions = [
    "Каково текущее состояние ваших волос?",
    "Каково текущее состояние кожи головы?",
    "Как часто вы моете голову с шампунем?",
    "Наблюдаете ли вы у себя выпадение или поредение волос? Если да, то как давно это происходит?",
    "Тест на натяжения волос: Возьмите 3-4 пряди волос (50-100 волосков) на разных участках головы слегка потяните и посчитайте количество выпавших волос",
    "Что из перечисленного применимо к вашему здоровью?",
    "Было ли у ваших родственников облысение?",
  ];

  List<List<String>> options = [
    [
      "Нормальные волосы",
      "Жесткие волосы",
      "Тонкие волосы",
      "Тусклые и ломкие волосы (секущиеся кончики)",
      "Аномалия цвета волос (седина)",
      "Обесцвеченные волосы (потеря пигмента от солнца, после окрашивания)",
    ],
    [
      "Кожа головы не имеет проблем",
      "Чувствительность, зуд или раздражение кожи головы",
      "Жирная кожа головы",
      "Сухая кожа головы",
      "Перхоть",
    ],
    [
      "1 раз в неделю",
      "2-3 раза в неделю",
      "Каждый день (привычка, тренировки)",
      "Каждый день (из-за повышенной жирности кожи головы)",
      "Более 1 раза в день",
    ],
    [
      "Менее 6 месяцев",
      "6-12 месяцев",
      "1-2 года",
      "2-5 лет",
      "5 лет и более",
      "У меня нет выпадения или поведения волос на голове",
    ],
    ["Менее 5 волос", "Более 5 волос"],
    [
      "Гормональные изменения или менопауза",
      "Период после операций или травм",
      "Я беременна",
      "Заболевания кожи (псориаз, экзема, себорейный дерматит и др.)",
      "Перенесенный Covid-19",
      "Заболевания щитовидной железы",
      "Стресс, депрессия, тревожные состояния",
      "Инфекционные заболевания",
      "Железодефицитная анемия",
      "Сахарный диабет",
      "Онкологическое заболевание",
      "Ничего из перечисленного",
    ],
    ["Было", "Ни у кого не было", "Я не знаю"],
  ];

  List<String> answers = List.generate(7, (index) => '');
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkUnfinishedTest();
  }

  Future<void> _checkUnfinishedTest() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot testDoc =
          await _firestore.collection('tests').doc(user.uid).get();
      if (testDoc.exists) {
        // Показать диалоговое окно, если тест был прерван
        _showContinueDialog(testDoc);
      }
    }
  }

  void _showContinueDialog(DocumentSnapshot testDoc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('У вас есть незаконченый тест'),
          content: Text('Хотите продолжить с последнего вопроса?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _resetTestState(); // Сбрасываем тест
                Navigator.pop(context);
              },
              child: Text('Нет'),
            ),
            TextButton(
              onPressed: () {
                // Загружаем состояние теста, когда нажимаем "Да"
                setState(() {
                  currentIndex = testDoc['currentIndex'];
                  answers = List<String>.from(testDoc['answers']);
                });
                Navigator.pop(context);
              },
              child: Text('Да'),
            ),
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    if (answers[currentIndex] != '') {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
        });
        _saveTestState();
      }
    }
  }

  void _prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _finishTest() {
    String diagnosis = _calculateDiagnosis();
    _saveTestState();
    _resetTestState(); // Сбрасываем состояние теста в Firebase
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HairCheckScreen(diagnosis: diagnosis),
      ),
    );
  }

  void _saveTestState() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('tests').doc(user.uid).set({
        'currentIndex': currentIndex,
        'answers': answers,
      });
    }
  }

  // Сбросить тест в Firebase
  void _resetTestState() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('tests').doc(user.uid).delete();
    }
  }

  String _calculateDiagnosis() {
    String diagnosis = '';
    String healthConditionAnswer = answers[5];

    if (healthConditionAnswer == "Гормональные изменения или менопауза") {
      diagnosis = 'Гормональные изменения или менопауза';
    } else if (healthConditionAnswer == "Период после операций или травм") {
      diagnosis = 'Период после операций или травм';
    } else if (healthConditionAnswer == "Я беременна") {
      diagnosis = 'Период беременности';
    } else if (healthConditionAnswer ==
        "Заболевания кожи (псориаз, экзема, себорейный дерматит и др.)") {
      diagnosis = 'Заболевания кожи';
    } else if (healthConditionAnswer == "Перенесенный Covid-19") {
      diagnosis = 'После COVID-19';
    } else if (healthConditionAnswer == "Заболевания щитовидной железы") {
      diagnosis = 'Заболевания щитовидной железы';
    } else if (healthConditionAnswer ==
        "Стресс, депрессия, тревожные состояния") {
      diagnosis = 'Стресс, депрессия, тревожные состояния';
    } else if (healthConditionAnswer == "Инфекционные заболевания") {
      diagnosis = 'Инфекционные заболевания';
    } else if (healthConditionAnswer == "Железодефицитная анемия") {
      diagnosis = 'Железодефицитная анемия';
    } else if (healthConditionAnswer == "Сахарный диабет") {
      diagnosis = 'Сахарный диабет';
    } else if (healthConditionAnswer == "Онкологическое заболевание") {
      diagnosis = 'Онкологическое заболевание';
    } else if (healthConditionAnswer == "Ничего из перечисленного") {
      diagnosis = 'Нет внутренних медицинских причин';
    } else {
      diagnosis = 'Неопределенный диагноз';
    }

    return diagnosis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тест для волос"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _exitTest,
            child: Text(
              'Выйти',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color.fromARGB(255, 65, 195, 255),
              ),
            ),
            SizedBox(height: 30),
            Text(
              questions[currentIndex],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                children:
                    options[currentIndex]
                        .map(
                          (option) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  answers[currentIndex] = option;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    answers[currentIndex] == option
                                        ? const Color.fromARGB(
                                          255,
                                          65,
                                          195,
                                          255,
                                        )
                                        : const Color.fromARGB(
                                          255,
                                          242,
                                          234,
                                          234,
                                        ),
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 18.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                option,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  ElevatedButton(
                    onPressed: _prevQuestion,
                    child: Text("Назад"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 65, 195, 255),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                if (currentIndex < questions.length - 1)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text("Далее"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 65, 195, 255),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                if (currentIndex == questions.length - 1)
                  ElevatedButton(
                    onPressed: _finishTest,
                    child: Text("Завершить тест"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 65, 195, 255),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _exitTest() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
