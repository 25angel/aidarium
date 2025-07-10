import 'package:flutter/material.dart';

// Main Input Screen
class AnalysisDecodingScreen extends StatefulWidget {
  @override
  _AnalysisDecodingScreenState createState() => _AnalysisDecodingScreenState();
}

class _AnalysisDecodingScreenState extends State<AnalysisDecodingScreen> {
  // Controllers for the input fields
  final Map<String, TextEditingController> _controllers = {};

  // Names of the tests
  final List<String> _testNames = [
    'Гемоглобин',
    'Железо',
    'Общий белок',
    'Альбумин',
    'Фолиевая кислота',
    'Витамин B12',
    'Цинк',
    'Витамин Д',
    'СОЭ',
    'Эритроциты',
    'Лейкоциты',
  ];

  // Normal ranges for each test
  final Map<String, Range> _normalRanges = {
    'Гемоглобин': Range(120, 160),
    'Железо': Range(9, 30),
    'Общий белок': Range(60, 80),
    'Альбумин': Range(35, 50),
    'Фолиевая кислота': Range(5, 35),
    'Витамин B12': Range(200, 900),
    'Цинк': Range(12, 18),
    'Витамин Д': Range(30, 100),
    'СОЭ': Range(2, 15),
    'Эритроциты': Range(3.8, 5.1),
    'Лейкоциты': Range(4.5, 9.0),
  };

  // Variables to store the values and results for each test
  double _hemoglobinValue = 0.0;
  double _ironValue = 0.0;
  String _hemoglobinResult = '';
  String _ironResult = '';
  String _totalProteinValue = '';
  String _totalProteinResult = '';
  double _albuminValue = 0.0;
  String _albuminResult = '';
  double _folicAcidValue = 0.0;
  String _folicAcidResult = '';
  double _vitaminB12Value = 0.0;
  String _vitaminB12Result = '';
  double _zincValue = 0.0;
  String _zincResult = '';
  double _vitaminDValue = 0.0;
  String _vitaminDResult = '';
  double _soeValue = 0.0;
  String _soeResult = '';
  double _erythrocytesValue = 0.0;
  String _erythrocytesResult = '';
  double _leukocytesValue = 0.0;
  String _leukocytesResult = '';

  @override
  void initState() {
    super.initState();
    for (var testName in _testNames) {
      _controllers[testName] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Clean up the controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Recommendations for Hemoglobin
  String _hemoglobinRecommendation(double value) {
    if (value < 120) {
      return '''Низкий уровень гемоглобина: при низком гемоглобине волосы недополучают кислород и питание, что вызывает их истончение и диффузное выпадение. Кожа головы становится сухой, может появиться шелушение и ощущение зуда. Рост новых волос замедляется, фолликулы переходят в фазу покоя.\n''';
    } else if (value > 160) {
      return '''Высокий уровень гемоглобина: повышенный гемоглобин делает кровь более густой, из-за чего замедляется микроциркуляция в коже головы. Это может привести к жирности, зудам или воспалениям кожи, а также к нарушению питания фолликулов. Волосы становятся ломкими, несмотря на кажущийся избыток кислорода.\n''';
    }
    return '''Нормальный уровень гемоглобина: при нормальном уровне обеспечивается стабильное кровоснабжение кожи головы и волосяных луковиц. Волосы растут полноценно, выглядят здоровыми и эластичными. Кожа головы увлажнена, без воспалений или избыточной жирности.\n''';
  }

  String _totalProteinRecommendation(double value) {
    if (value < 60) {
      return '''Низкий уровень общего белка: недостаток белка может привести к истончению волос, их ломкости и выпадению. Кожа головы становится сухой и может шелушиться. Это также может вызвать замедление роста новых волос и ухудшение состояния уже существующих.\n''';
    } else if (value > 80) {
      return '''Высокий уровень общего белка: избыток белка может привести к избыточной жирности кожи головы, что вызывает зуд и воспаление. Волосы могут стать тусклыми и ломкими, а также могут возникнуть проблемы с их ростом.\n''';
    }
    return '''Нормальный уровень общего белка: нормальный уровень обеспечивает здоровье волос и кожи головы. Волосы выглядят блестящими и здоровыми, кожа головы увлажнена и без воспалений.\n''';
  }

  // Recommendations for Iron
  String _ironRecommendation(double value) {
    if (value < 9) {
      return '''Низкий уровень железа: при дефиците железа нарушается доставка кислорода к волосяным фолликулам, что приводит к замедлению роста и диффузному выпадению волос. Волосы становятся тусклыми, ломкими, а кожа головы может быть сухой и чувствительной. Это одна из самых частых причин телогеновой алопеции, особенно у женщин.\n''';
    } else if (value > 30) {
      return '''Повышенный уровень железа: избыточное железо может накапливаться в тканях и вызывать окислительный стресс, что негативно влияет на кожу и корни волос. Это может проявляться раздражением, жирной кожей головы и нарушением регенерации фолликулов. В редких случаях приводит к воспалительным реакциям и ухудшению качества волос.\n''';
    }
    return '''Нормальный уровень железа: нормальный уровень железа обеспечивает хорошее питание и насыщение фолликулов кислородом. Волосы растут равномерно, отличаются плотностью и блеском. Кожа головы выглядит здоровой, без признаков воспаления или шелушения.\n''';
  }

  String _albuminRecommendation(double value) {
    if (value < 35) {
      return '''Низкий уровень альбумина: альбумин — это основной белок плазмы, участвующий в транспорте питательных веществ, включая витамины и микроэлементы, к коже и волосам. При его снижении ухудшается питание волосяных фолликулов, что приводит к выпадению, замедленному росту и сухости кожи головы. Также может наблюдаться отёчность и вялость кожи.\n''';
    } else if (value > 50) {
      return '''Нормальный уровень альбумина: нормальный уровень альбумина обеспечивает хорошее снабжение кожи и волос необходимыми веществами, поддерживает водный баланс тканей. Волосы при этом растут равномерно, выглядят блестящими, а кожа головы — гладкой и увлажнённой. Это один из признаков сбалансированного белкового обмена.\n''';
    }
    return '''Высокий уровень альбумина: повышенный альбумин чаще всего связан с обезвоживанием, а не с избыточным белком. Это может сопровождаться сухостью кожи головы, шелушением и временным ухудшением состояния волос. Восстановление водно-белкового баланса обычно приводит к нормализации состояния.\n''';
  }

  String _folicAcidRecommendation(double value) {
    if (value < 5) {
      return '''Низкий уровень фолиевой кислоты: фолиевая кислота необходима для деления клеток, синтеза ДНК и нормального кроветворения, включая питание волосяных фолликулов. При её дефиците нарушается обновление кожи головы и замедляется рост волос, наблюдается выпадение, тусклость и ломкость. Также кожа может становиться сухой, раздражённой или шелушащейся.\n''';
    } else if (value > 35) {
      return '''Нормальный уровень фолиевой кислоты: нормальный уровень обеспечивает стабильную регенерацию клеток кожи и волос, улучшает микроциркуляцию кожи головы и способствует насыщению фолликулов кислородом. Волосы при этом растут активно, выглядят крепкими и блестящими. Кожа головы остаётся ровной, без шелушения или воспалений.\n''';
    }
    return '''Высокий уровень фолиевой кислоты: повышение обычно бывает при приёме витаминов в высоких дозах и не оказывает прямого негативного влияния на волосы. Однако чрезмерное употребление может маскировать дефицит витамина B12, что косвенно влияет на рост и качество волос. Поэтому важно контролировать баланс витаминов группы B.\n''';
  }

  String _vitaminB12Recommendation(double value) {
    if (value < 200) {
      return '''Низкий уровень витамина B12: витамин B12 играет ключевую роль в делении клеток, синтезе ДНК, кроветворении и работе нервной системы. При его дефиците нарушается питание волосяных фолликулов, что приводит к замедленному росту, истончению и выпадению волос. Кожа головы может становиться сухой, бледной, иногда возникает зуд или покалывание.\n''';
    } else if (value > 900) {
      return '''Нормальный уровень витамина B12: при нормальном уровне B12 обеспечивается здоровое деление клеток кожи и волос, нормальное кровоснабжение и поступление кислорода к тканям. Волосы выглядят густыми, блестящими, растут равномерно, кожа головы — ровная и увлажнённая. Это оптимальный уровень для поддержания нормального цикла роста волос.\n''';
    }
    return '''Высокий уровень витамина B12: повышенный B12 чаще всего возникает при инъекционном или высокодозном приёме витаминов. Обычно не вызывает негативных эффектов, но при сильно завышенных уровнях может наблюдаться повышенная жирность кожи или раздражения. Для волос критической опасности нет, однако избыток без показаний не даёт дополнительной пользы.\n''';
  }

  String _zincRecommendation(double value) {
    if (value < 12) {
      return '''Низкий уровень цинка: при низком уровне цинка нарушается работа волосяных фолликулов, что приводит к выпадению волос, повышенной ломкости, перхоти и зуду кожи головы. Также может наблюдаться жирная себорея, акне и обострение воспалительных процессов на коже.\n''';
    } else if (value > 18) {
      return '''Нормальный уровень цинка: при достаточном уровне цинка обеспечивается здоровая регенерация клеток кожи головы, нормальная работа сальных желёз и стабильный рост волос. Волосы становятся плотными, блестящими и устойчивыми к внешним воздействиям, а кожа головы — сбалансированной, без раздражений и жирности. Также цинк поддерживает иммунитет кожи и защищает от грибковых инфекций.\n''';
    }
    return '''Высокий уровень цинка: высокий уровень чаще всего связан с длительным или чрезмерным приёмом добавок. Это может вызывать дефицит меди, что, в свою очередь, приводит к ухудшению структуры волос. В редких случаях возможны раздражения кожи, сухость, замедление роста волос при нарушении минерального баланса.\n''';
  }

  String _vitaminDRecommendation(double value) {
    if (value < 30) {
      return '''Низкий уровень витамина D: витамин D необходим для нормального кроветворения, укрепления костей и зубов, а также для поддержания иммунной системы, включая питание волосяных фолликулов. При его дефиците нарушается обновление кожи головы и замедляется рост волос, наблюдается выпадение, тусклость и ломкость. Также кожа может становиться сухой, раздражённой или шелушащейся.\n''';
    } else if (value > 100) {
      return '''Нормальный уровень витамина D: нормальный уровень обеспечивает стабильную регенерацию клеток кожи и волос, улучшает микроциркуляцию кожи головы и способствует насыщению фолликулов кислородом. Волосы при этом растут активно, выглядят крепкими и блестящими. Кожа головы остаётся ровной, без шелушения или воспалений.\n''';
    }
    return '''Высокий уровень витамина D: повышение обычно бывает при приёме витаминов в высоких дозах и не оказывает прямого негативного влияния на волосы. Однако чрезмерное употребление может маскировать дефицит витамина D, что косвенно влияет на рост и качество волос. Поэтому важно контролировать баланс витаминов.\n''';
  }

  String _soeRecommendation(double value) {
    if (value < 2) {
      return '''Низкий уровень СОЭ: низкое уровень СОЭ встречается редко и не оказывает прямого негативного влияния на волосы. В некоторых случаях может указывать на повышенную вязкость крови или нарушения кровообращения, из-за чего питание кожи головы и волосяных фолликулов может быть слабоэффективным. Это может проявляться замедленным ростом волос и лёгкой сухостью кожи головы.\n''';
    } else if (value > 15) {
      return '''Нормальный уровень СОЭ: нормальный СОЭ обеспечивает стабильное кровоснабжение кожи головы, нормальный цикл роста волос и здоровое состояние кожи. Волосы в таком состоянии растут равномерно, кожа головы не воспалена, без шелушения или зуда.\n''';
    }
    return '''Высокий уровень СОЭ: повышенное значение СОЭ — неспецифический маркер воспаления, часто указывает на инфекцию, аутоиммунный процесс, хронический стресс или скрытые болезни. У людей с высокой СОЭ может наблюдаться диффузное или очаговое выпадение волос, воспаление кожи головы, зуд, шелушение или жирность. Важно учитывать СОЭ в комплексе с другими показателями (лейкоцитами, С-реактивным белком).\n''';
  }

  String _erythrocytesRecommendation(double value) {
    if (value < 3.8) {
      return '''Низкий уровень эритроцитов: при низком уровне эритроцитов нарушается питание волосяных фолликулов, что приводит к замедленному росту, истончению и выпадению волос. Кожа головы может становиться сухой, бледной, иногда возникает зуд или покалывание.\n''';
    } else if (value > 5.1) {
      return '''Нормальный уровень эритроцитов: нормальный уровень обеспечивает стабильную регенерацию клеток кожи и волос, улучшает микроциркуляцию кожи головы и способствует насыщению фолликулов кислородом. Волосы при этом растут активно, выглядят крепкими и блестящими. Кожа головы остаётся ровной, без шелушения или воспалений.\n''';
    }
    return '''Высокий уровень эритроцитов: повышенный уровень эритроцитов может указывать на сгущение крови, что затрудняет микроциркуляцию в коже головы. Это может привести к недостаточному питанию волосяных фолликулов и замедлению роста волос.\n''';
  }

  String _leukocytesRecommendation(double value) {
    if (value < 4.0) {
      return '''Низкий уровень лейкоцитов: лейкоциты — это белые кровяные клетки, отвечающие за иммунную защиту организма. При их снижении ослабевает местный иммунитет кожи головы, что делает её уязвимой к грибковым и бактериальным инфекциям, а также может способствовать развитию перхоти, воспаления и зуда. Волосы становятся ослабленными, а при длительном иммунодефиците возможно выпадение на фоне скрытых воспалений.\n''';
    } else if (value > 9.0) {
      return '''Нормальный уровень лейкоцитов: нормальный уровень лейкоцитов свидетельствует о стабильной работе иммунной системы. Это обеспечивает здоровую кожу головы без воспалений, препятствует развитию инфекций и способствует устойчивому росту волос. Волосы при этом сохраняют естественную густоту, эластичность и блеск.\n''';
    }
    return '''Высокий уровень лейкоцитов: повышенные лейкоциты указывают на наличие воспаления, инфекции или аутоиммунного процесса в организме. Это может сопровождаться зудом, покраснением кожи головы, перхотью или высыпаниями, а также очаговым или диффузным выпадением волос. Особенно важно учитывать лейкоциты в сочетании с СОЭ и С-реактивным белком.\n''';
  }

  // Submit the analysis results
  void _submitAnalysis() {
    String analysisResults = '';
    String recommendations = '';

    _controllers.forEach((testName, controller) {
      String value = controller.text;
      analysisResults +=
          '$testName: $value\nНорма: ${_normalRanges[testName]!.min} - ${_normalRanges[testName]!.max}\n';

      if (value.isNotEmpty) {
        double numericValue = double.tryParse(value) ?? 0.0;
        Range? range = _normalRanges[testName];
        if (range != null) {
          // Store the values and results for each test
          if (testName == 'Гемоглобин') {
            _hemoglobinValue = numericValue;
            _hemoglobinResult = _hemoglobinRecommendation(numericValue);
          } else if (testName == 'Железо') {
            _ironValue = numericValue;
            _ironResult = _ironRecommendation(numericValue);
          } else if (testName == 'Общий белок') {
            _totalProteinValue = numericValue.toString();
            _totalProteinResult = _totalProteinRecommendation(numericValue);
          } else if (testName == 'Эритроциты') {
            _erythrocytesValue = numericValue;
            _erythrocytesResult = _erythrocytesRecommendation(numericValue);
          } else if (testName == "Лейкоциты") {
            _leukocytesValue = numericValue;
            _leukocytesResult = _leukocytesRecommendation(numericValue);
          } else if (testName == "Альбумин") {
            _albuminValue = numericValue;
            _albuminResult = _albuminRecommendation(numericValue);
          } else if (testName == "Фолиевая кислота") {
            _folicAcidValue = numericValue;
            _folicAcidResult = _folicAcidRecommendation(numericValue);
          } else if (testName == "Витамин B12") {
            _vitaminB12Value = numericValue;
            _vitaminB12Result = _vitaminB12Recommendation(numericValue);
          } else if (testName == "Цинк") {
            _zincValue = numericValue;
            _zincResult = _zincRecommendation(numericValue);
          } else if (testName == "Витамин Д") {
            _vitaminDValue = numericValue;
            _vitaminDResult = _vitaminDRecommendation(numericValue);
          } else if (testName == "СОЭ") {
            _soeValue = numericValue;
            _soeResult = _soeRecommendation(numericValue);
          }
        }
      }
    });

    // Navigate to the result screen with the analysis results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AnalysisResultScreen(
              result: analysisResults,
              diagnosis: recommendations,
              hemoglobinValue: _hemoglobinValue,
              ironValue: _ironValue,
              hemoglobinResult: _hemoglobinResult,
              ironResult: _ironResult,
              totalProteinValue: _totalProteinValue,
              totalProteinResult: _totalProteinResult,
              erythrocytesValue: _erythrocytesValue,
              erythrocytesResult: _erythrocytesResult,

              folicAcidValue: _folicAcidValue,
              folicAcidResult: _folicAcidResult,
              soeValue: _soeValue,
              soeResult: _soeResult,
              vitaminB12Value: _vitaminB12Value,
              vitaminB12Result: _vitaminB12Result,
              vitaminDValue: _vitaminDValue,
              vitaminDResult: _vitaminDResult,
              zincValue: _zincValue,
              zincResult: _zincResult,
              albuminValue: _albuminValue,
              albuminResult: _albuminResult,
              leukocytesValue: _leukocytesValue,
              leukocytesResult: _leukocytesResult,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расшифровка анализов'),
        backgroundColor: const Color.fromARGB(255, 65, 195, 255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'План обследования',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Сдайте кровь и загрузите следующие анализы:',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 15),
            Text(
              '• Клинический анализ крови\n• Биохимический анализ крови\n• Гормоны\n• Витамины и микроэлементы',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 25),
            // Input field for each test
            for (var testName in _testNames) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '$testName',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              TextField(
                controller: _controllers[testName],
                decoration: InputDecoration(
                  labelText: 'Введите значение',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
            ],
            // Submit button
            ElevatedButton(
              onPressed: _submitAnalysis,
              child: Text('Отправить анализы'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 65, 195, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 18),
                minimumSize: Size(double.infinity, 55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Analysis Result Screen
class AnalysisResultScreen extends StatelessWidget {
  final String result;
  final String diagnosis;
  final double hemoglobinValue;
  final double ironValue;
  final String hemoglobinResult;
  final String ironResult;
  final String totalProteinValue;
  final String totalProteinResult;
  final double erythrocytesValue;
  final String erythrocytesResult;
  final double leukocytesValue;
  final String leukocytesResult;
  final double folicAcidValue;
  final String folicAcidResult;
  final double albuminValue;
  final String albuminResult;
  final double vitaminB12Value;
  final String vitaminB12Result;
  final double zincValue;
  final String zincResult;
  final double vitaminDValue;
  final String vitaminDResult;
  final double soeValue;
  final String soeResult;

  const AnalysisResultScreen({
    Key? key,
    required this.result,
    required this.diagnosis,
    required this.hemoglobinValue,
    required this.ironValue,
    required this.hemoglobinResult,
    required this.ironResult,
    required this.totalProteinValue,
    required this.totalProteinResult,
    required this.erythrocytesValue,
    required this.erythrocytesResult,
    required this.folicAcidValue,
    required this.folicAcidResult,
    required this.albuminValue,
    required this.albuminResult,
    required this.vitaminB12Value,
    required this.vitaminB12Result,
    required this.zincValue,
    required this.zincResult,
    required this.vitaminDValue,
    required this.vitaminDResult,
    required this.soeValue,
    required this.soeResult,
    required this.leukocytesValue,
    required this.leukocytesResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты анализа'),
        backgroundColor: const Color.fromARGB(255, 65, 195, 255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 42.0), // Левый отступ
              child: Text(
                'Гемоглобин: $hemoglobinValue (норма: 120 - 160)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign:
                    TextAlign.start, // Выравнивание текста по левому краю
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                hemoglobinResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),

            Divider(color: Colors.black),

            // Displaying the iron result
            Padding(
              padding: const EdgeInsets.only(
                right: 107.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Железо: $ironValue (норма: 9 - 30)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                ironResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Общий белок: $totalProteinValue (норма: 60 - 80)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                totalProteinResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),

            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Альбумин: $albuminValue (норма: 35 - 50)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                albuminResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Фолиевая кислота: $folicAcidValue (норма: 5 - 35)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                folicAcidResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Витамин B12: $vitaminB12Value (норма: 200 - 900)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                vitaminB12Result,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Цинк: $zincValue (норма: 12 - 18)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                zincResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Витамин Д: $vitaminDValue (норма: 30 - 100)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                vitaminDResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'СОЭ: $soeValue (норма: 2 - 15)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                soeResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Эритроциты: $erythrocytesValue (норма: 3,8 - 5,1)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                erythrocytesResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.only(
                right: 43.0,
              ), // Left padding to align with the left wall
              child: Text(
                'Лейкоциты: $leukocytesValue (норма: 4,0 - 9,0)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ), // Left padding for the result description
              child: Text(
                leukocytesResult,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Range {
  final double min;
  final double max;

  Range(this.min, this.max);
}
