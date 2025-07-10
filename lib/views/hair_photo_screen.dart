import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'hair_result_screen.dart'; // Новый экран с результатом

class HairPhotoScreen extends StatefulWidget {
  @override
  _HairPhotoScreenState createState() => _HairPhotoScreenState();
}

class _HairPhotoScreenState extends State<HairPhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String _result = '';
  String _errorMessage = '';
  String _diagnosisText = '';

  // Функция для выбора фото с камеры
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      _sendImageForDetection();
    }
  }

  // Функция для выбора фото из галереи
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      _sendImageForDetection();
    }
  }

  // Функция для отправки фото на сервер Roboflow для анализа
  Future<void> _sendImageForDetection() async {
    if (_image == null) {
      setState(() {
        _errorMessage = 'Пожалуйста, выберите изображение.';
      });
      return;
    }

    try {
      final file = File(_image!.path);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      final url =
          'https://detect.roboflow.com/hair_detect-v700d/9?api_key=5wVvvjcAvstpjtG7pFHd&confidence=1';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: base64Image,
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final predictions = result['predictions'] as List<dynamic>;

        if (predictions.isEmpty) {
          setState(() {
            _errorMessage = 'Не удалось получить результат.';
            _result = '';
          });
          return;
        }

        // Фильтруем предсказания с уверенностью менее 1%
        final validPredictions =
            predictions
                .where((pred) => (pred['confidence'] as num) >= 0.01)
                .toList();

        if (validPredictions.isEmpty) {
          setState(() {
            _errorMessage =
                'Не найдено достоверных результатов (порог уверенности 1%).';
            _result = '';
          });
          return;
        }

        validPredictions.sort(
          (a, b) => (b['confidence'] as num).compareTo(a['confidence']),
        );
        final label = (validPredictions.first['class'] as String).toLowerCase();

        setState(() {
          if (label == 'hair_oily') {
            _result = 'Жирные волосы';
            _diagnosisText = _getRecommendations('Жирные волосы и кожа головы');
          } else if (label == 'hair_loss') {
            _result = 'Выпадение волос';
            _diagnosisText = _getRecommendations('Выпадение волос');
          } else if (label == 'hair_dandruff') {
            _result = 'Перхоть';
            _diagnosisText = _getRecommendations('Перхоть');
          } else if (label == 'hair_diffuse') {
            _result = 'Диффузное истончение волос';
            _diagnosisText = _getRecommendations('Диффузное истончение волос');
          } else if (label == 'hair_red') {
            _result = 'Раздражение кожи головы';
            _diagnosisText = _getRecommendations('Раздражение кожи головы');
          } else if (label == 'hair_healthy') {
            _result = 'Здоровые волосы';
            _diagnosisText = _getRecommendations('Здоровые волосы');
          } else {
            _diagnosisText = 'Фото не подходит для проверки.';
          }
        });

        // Переход на экран с результатом
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => HairResultScreen(
                  result: _result,
                  diagnosis: _diagnosisText,
                  imagePath: _image!.path,
                ),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Ошибка при обработке запроса. Статус: ${response.statusCode}';
          _result = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при отправке запроса: $e';
        _result = '';
      });
    }
  }

  // Получаем рекомендации на основе диагноза
  String _getRecommendations(String diagnosis) {
    if (diagnosis == 'Жирные волосы и кожа головы') {
      return """
      Рекомендации:
 • Используйте мягкие шампуни для жирной кожи головы с кислотами (например, AHA или салициловой кислотой).
 • Избегайте агрессивных очищающих средств — они провоцируют усиленную выработку себума.
 • Не мойте голову слишком часто — оптимально через день.
 • Делайте глиняные маски для кожи головы 1–2 раза в неделю (например, с зелёной или голубой глиной).
 • Не наносите кондиционер у корней — только по длине.
      """;
    } else if (diagnosis == 'Выпадение волос') {
      return """
      Рекомендации:
      • Пройдите медицинское обследование на гормональный фон, щитовидную железу и уровень ферритина.
 • Используйте тоники и спреи с активными веществами (миноксидил, аденозин, экстракт плаценты).
 • Делайте домашний или профессиональный массаж кожи головы ежедневно.
 • Применяйте курсы мезотерапии, плазмолифтинга (по назначению специалиста).
 • Обеспечьте полноценный сон, физическую активность и снижение уровня стресса.
      """;
    } else if (diagnosis == 'Перхоть') {
      return """
      Рекомендации:
 • Используйте лечебные шампуни с кетоконазолом, пиритионом цинка или салициловой кислотой 2–3 раза в неделю.
 • Избегайте силиконов и тяжёлых масел в составе косметики.
 • Не перегревайте кожу головы (фен, солнечное воздействие).
 • Протирайте кожу головы настоем крапивы или отваром ромашки как противовоспалительное средство.
 • Обратите внимание на питание: ограничьте сахар, молочные продукты и жирную пищу.
      
      """;
    } else if (diagnosis == 'Диффузное истончение волос') {
      return """
     Рекомендации:
 • Убедитесь в отсутствии дефицита железа, витаминов D и B12 — при необходимости проконсультируйтесь с врачом.
 • Используйте шампуни и тоники с кофеином, биотином или ниацинамидом для стимуляции роста волос.
 • Избегайте стрессов — они часто провоцируют истончение.
 • Включите в уход укрепляющие ампулы, сыворотки или спреи с миноксидилом (после консультации с трихологом).
 • Минимизируйте использование тугих причёсок и тугих резинок.
      
      """;
    } else if (diagnosis == 'Раздражение кожи головы') {
      return """
      Рекомендации:
 • Исключите использование продуктов с сульфатами, спиртом и отдушками.
 • Используйте успокаивающие средства с пантенолом, алоэ вера, бетаином.
 • Временно прекратите окрашивание, ламинирование и использование термоприборов.
 • Протирайте кожу головы отварами календулы, ромашки или раствором хлоргексидина.
 •  • Обратитесь к дерматологу или трихологу для исключения дерматита или аллергии.
      """;
    } else if (diagnosis == 'Здоровые волосы') {
      return """
      Рекомендации:
 • Поддерживайте текущий режим ухода: используйте мягкий шампунь и кондиционер, подходящие вашему типу волос.
 • Ограничьте термоукладку и химические процедуры.
 • Следите за питанием и уровнем витаминов (особенно A, E, D и группы B).
 • Делайте регулярный массаж кожи головы для улучшения кровообращения.
 • Используйте натуральные маски 1 раз в неделю (например, на основе масла жожоба или кокоса).
      
      """;
    }
    // Добавьте другие диагнозы и рекомендации по аналогии
    return 'Рекомендации по вашему диагнозу будут отображены здесь.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Загрузка фото для анализа'),
        backgroundColor: Color(0xFF41C3FF),
        elevation: 4,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Центрирование контента
          children: [
            // Иконка и фото
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/hair_example.png', // Фото с примером для съемки
                height: 350,
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Текст с инструкциями
            Text(
              'Нажмите кнопку ниже, чтобы загрузить фото для анализа.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),

            // Результат или сообщение об ошибке
            if (_result.isNotEmpty) ...[
              Text(
                _result,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
            if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Text('Галерея'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF41C3FF),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _takePhoto,
                child: Text('Камера'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF41C3FF),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
