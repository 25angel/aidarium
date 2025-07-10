import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompatibilityCheckScreen extends StatefulWidget {
  @override
  _CompatibilityCheckScreenState createState() =>
      _CompatibilityCheckScreenState();
}

class _CompatibilityCheckScreenState extends State<CompatibilityCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _scalpType = 'Жирная'; // Тип кожи головы (с выбором)
  String? _selectedProblem = 'Нет проблем'; // Проблемы, которые нужно решить
  String _brands = '';
  String _recommendation = '';
  String _problem = '';
  List<String> _shampoos = []; // Храним названия шампуней для сравнения
  bool showImage = true; // Flag to control image visibility

  // Список вариантов для типа кожи головы
  List<String> _scalpTypes = [
    'Жирная',
    'Сухая',
    'Нормальная',
    'Комбинированная',
  ];

  // Список проблем с волосами
  List<String> _problems = [
    'Выпадение',
    'Ломкость',
    'Перхоть',
    'Зуд',
    'Нет проблем',
  ];

  // Функция для формирования рекомендации на основе введённых данных
  void _getRecommendation() {
    setState(() {
      _problem = '';
      _recommendation = ''; // Сброс старых рекомендаций
      _shampoos = [];

      // Обрабатываем тип кожи головы
      if (_scalpType == 'Жирная' && _selectedProblem == 'Перхоть') {
        _problem =
            'У вас жирная кожа головы с перхотью. Некоторые из используемых средств содержат сульфаты и силиконы, которые могут усиливать жирность и вызывать раздражение.';
        _recommendation =
            "Рекомендуем: Шампунь с пиритионом цинка или кетоконазолом 2–3 раза в неделю, в другие дни — мягкий шампунь без сульфатов. Не наносите маски и масла у корней. 1 раз в неделю — пилинг для кожи головы.";

        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Nizoral',
          'Ducray Kelual DS',
          'Libriderm Zinc',
          'Vichy Dercos Micropeel',
        ];
      }

      // Рекомендуем по проблемам
      if (_scalpType == 'Сухая' && _selectedProblem == 'Ломкость') {
        _problem =
            'У вас сухая кожа головы и ломкие волосы. Используемые средства могут пересушивать волосы и усиливать их хрупкость.';
        _recommendation =
            "Рекомендуем: Используйте увлажняющие шампуни без сульфатов. 2 раза в неделю наносите восстанавливающие маски с кератином. Используйте несмываемый уход кремы или масла. Избегайте частой термоукладки и расчёсывания мокрых волос.";

        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Lador Moisture Balancing',
          'Ollin Megapolis',
          'Loreal Elseve',
        ];
      }

      if (_scalpType == 'Нормальная' && _selectedProblem == 'Выпадение') {
        _problem =
            'У вас нормальная кожа головы и наблюдается выпадение волос. Ваш уход не направлен на решение этой проблемы.';
        _recommendation =
            "Рекомендуем: Шампуни с активами против выпадения, применяйте ампулы или сыворотки. Делайте массаж кожи головы ежедневно 5–10 мин. При необходимости сдайте анализы на ферритин, витамин D и B12.";

        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = ['Vichy Dercos Energising', 'Loreal Aminexil'];
      }
      if (_scalpType == 'Комбинированная' &&
          _selectedProblem == 'Нет проблем') {
        _problem =
            'У вас комбинированная кожа головы, и вы не испытываете серьёзных проблем.';
        _recommendation =
            "Рекомендуем: Мягкий, очищающий, но не агрессивный шампунь. На длину наносите бальзам или маску с маслами, но не наносите на корни. 1–2 раза в неделю используйте масло или крем для кончиков. Раз в неделю можно использовать сухой шампунь вместо обычного мытья, чтобы не пересушивать концы.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = ['Lador Derma', 'Schwarzkopf Bonacure', 'Batiste'];
      }
      if (_scalpType == 'Нормальная' && _selectedProblem == 'Перхоть') {
        _problem =
            'У вас нормальная кожа головы, но присутствует перхоть. Текущие средства могут временно маскировать проблему, но при длительном использовании пересушивают кожу и не устраняют причину появления перхоти.';
        _recommendation =
            "Рекомендуем: Используйте лечебный шампунь с антимикотическим компонентом 2–3 раза в неделю. В остальные дни — мягкий шампунь без сульфатов и силиконов. 1 раз в неделю — пилинг кожи головы для очищения и отшелушивания. После мытья используйте успокаивающий лосьон или тоник.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Bioderma Node DS+',
          'Libriderm',
          'Vichy Micropeel',
          'Ducray Squanorm Lotion',
        ];
      }
      if (_scalpType == 'Комбинированная' && _selectedProblem == 'Ломкость') {
        _problem =
            'У вас комбинированная кожа головы и выраженная ломкость волос. Текущий уход может перегружать корни и не давать необходимого увлажнения по длине.';
        _recommendation =
            "Рекомендуем: Используйте мягкий очищающий шампунь для комбинированной кожи головы, 2–3 раза в неделю наносите глубоко восстанавливающую маску.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = ['Lador Triplex', 'Lador Hydro LPP'];
      }
      if (_scalpType == 'Нормальная' && _selectedProblem == 'Ломкость') {
        _problem =
            'У вас нормальная кожа головы и выраженная ломкость волос. Чтобы улучшить структуру волос, важно сосредоточиться на питании длины и термозащите.';
        _recommendation =
            "Рекомендуем: Используйте мягкие, увлажняющие или восстанавливающие шампуни без сульфатов. Используйте маски для ухода за длиной. После каждого мытья наносите несмываемое средство с термозащитой.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Lador Moisture Balancing',
          'Lador Hydro LPP Treatment',
          'Kerastase Nutritive Nectar Thermique',
        ];
      }
      if (_scalpType == 'Жирная' && _selectedProblem == 'Выпадение') {
        _problem =
            'У вас жирная кожа головы и наблюдается выпадение волос. Необходим двойной уход — регулирующий кожное сало и укрепляющий фолликулы. Отсутствие стимуляторов роста в используемых средствах и избыток силиконов может тормозить восстановление.';
        _recommendation =
            "Рекомендуем: 2–3 раза в неделю используйте шампунь от выпадения с активами (кофеин, ниацинамид, аминексил), 1–2 раза в неделю — пилинг кожи головы для очищения пор и улучшения кровообращения. Массаж кожи головы 5–10 минут в день - улучшает микроциркуляцию и доставку питательных веществ к корням.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Vichy Dercos Energising',
          'CP-1 Scalp Scaler',
          'CP-1 Scalp Tonic',
        ];
      }
      if (_scalpType == 'Жирная' && _selectedProblem == 'Ломкость') {
        _problem =
            'У вас жирная кожа головы и ломкие волосы. Текущий уход может усиливать сальность, при этом не обеспечивая полноценного увлажнения и питания длины. Рекомендуется использовать раздельный и сбалансированный уход, направленный на восстановление структуры волос, без перегрузки кожи головы.';
        _recommendation =
            "Рекомендуем: Используйте лёгкие очищающие шампуни без агрессивных ПАВов, маски и питание (только на длину), после мытья используйте несмываемые кремы/сыворотки на концы.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'La Roche-Posay Kerium',
          'Estel Curex Therapy',
          'Kerastase Nutritive 8H Magic Night Serum',
        ];
      }
      if (_scalpType == 'Жирная' && _selectedProblem == 'Зуд') {
        _problem =
            'У вас жирная кожа головы с выраженным зудом. Используемые средства могут провоцировать раздражение и нарушать микрофлору кожи, усугубляя проблему. Для нормализации состояния кожи важно выбрать деликатный, регулирующий и успокаивающий уход.';
        _recommendation =
            "Рекомендуем: Успокаивающий и себорегулирующий уход, 1 раз в неделю — пилинг кожи головы для снятия зуда и ороговевших клеток, После каждого мытья — успокаивающий лосьон/тоник.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Bioderma Node DS+',
          'Vichy Dercos Micropeel',
          'Ducray Squanorm Lotion',
        ];
      }
      if (_scalpType == 'Нормальная' && _selectedProblem == 'Зуд') {
        _problem =
            'У вас нормальная кожа головы, но присутствует зуд, который, скорее всего, вызван раздражающим или неподходящим составом уходовых средств. Необходимо перейти на успокаивающий, мягкий уход, не пересушивающий кожу головы.';
        _recommendation =
            "Рекомендуем: Используйте гипоаллергенные и успокаивающие шампуни, которые не содержат сульфатов и отдушек, 1 раз в неделю — мягкий пилинг кожи головы, чтобы удалить ороговевшие клетки и снизить зуд, после мытья наносите тоник или лосьон против зуда.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Libriderm',
          'Estel Otium Detox',
          'Esthetic House Hair Tonic',
        ];
      }
      if (_scalpType == 'Сухая' && _selectedProblem == 'Нет проблем') {
        _problem =
            'У вас сухая кожа головы без выраженных проблем. Важно не допустить их появления, поэтому рекомендуется перейти на более мягкий и увлажняющий уход, даже если вас пока всё устраивает. Профилактика = здоровье волос в долгосрочной перспективе.';
        _recommendation =
            "Рекомендуем: Используйте увлажняющие шампуни без сульфатов, подходящие для сухой кожи, 1–2 раза в неделю используйте увлажняющие маски или кондиционеры, только на длину, несмываемый спрей или крем по желанию.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'CeraVe Hydrating Cleanser for Scalp',
          'Lador Hydro LPP',
          'Revlon Uniq One',
        ];
      }
      if (_scalpType == 'Сухая' && _selectedProblem == 'Зуд') {
        _problem =
            'У вас сухая кожа головы и зуд, что указывает на раздражение или обезвоживание кожи. Текущий уход может усугублять состояние, поэтому важно перейти на успокаивающий и увлажняющий уход, предназначенный для чувствительной и сухой кожи головы.';
        _recommendation =
            "Рекомендуем: Шампуни (мягкие и без сульфатов), после мытья наносите успокаивающий тоник, 1 раз в неделю — мягкий пилинг кожи головы, чтобы убрать ороговевшие клетки и восстановить дыхание кожи, 2–3 раза в неделю — питательная маска для длины.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = ['Libriderm', 'CP-1 Scalp Tonic', 'Estel Curex Therapy'];
      }
      if (_scalpType == 'Жирная' && _selectedProblem == 'Нет проблем') {
        _problem =
            'У вас жирная кожа головы без явных проблем — это отличный старт. Чтобы сохранить здоровье кожи головы и волос, важно использовать поддерживающий уход, который будет регулировать выработку себума и не перегружать корни.';
        _recommendation =
            "Рекомендуем: Шампуни (регулирующие и лёгкие), 1 раз в неделю — пилинг кожи головы, чтобы удалить излишки кожного сала и остатки средств, лёгкий тоник для поддержки баланса кожи головы.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'La Roche-Posay Kerium Oil Control',
          'Davines Detoxifying Scrub',
          'Esthetic House Hair Tonic',
        ];
      }
      if (_scalpType == 'Сухая' && _selectedProblem == 'Выпадение') {
        _problem =
            'У вас сухая кожа головы и наблюдается выпадение волос. Текущий уход может усугублять сухость и снижать питание волосяных луковиц. Необходимо сочетать увлажняющий уход с активными средствами против выпадения, не раздражая кожу головы.';
        _recommendation =
            "Рекомендуем: Шампуни (мягкие и укрепляющие), 2–3 раза в неделю — восстанавливающая маска по длине, без нанесения на корни, после мытья — несмываемая увлажняющая сыворотка/спрей на кончики, стимулирующие средства против выпадения (по желанию).";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Klorane Quinine & Edelweiss',
          'Lador Hydro LPP',
          'System 4 Serum',
        ];
      }
      if (_scalpType == 'Сухая' && _selectedProblem == 'Перхоть') {
        _problem =
            'У вас сухая кожа головы с перхотью, и текущие средства могут усугублять состояние, вызывая ещё большее шелушение. Необходимо использовать деликатный, увлажняющий и противовоспалительный уход, направленный на восстановление баланса кожи.';
        _recommendation =
            "Рекомендуем: Лечебные шампуни, 1 раз в неделю — мягкий пилинг кожи головы, чтобы убрать ороговевшие клетки, маска 1–2 раза в неделю по длине, не на кожу.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'La Roche-Posay Kerium DS',
          'Ecolab Scalp Peeling',
          'Kaaral Hydra',
        ];
      }
      if (_scalpType == 'Нормальная' && _selectedProblem == 'Нет проблем') {
        _problem =
            'Если вы используете шампуни и средства (например, Pantene, Elseve, Garnier и т. д.) и они полностью вам подходят — не вызывают зуда, жирности, сухости или других неприятных ощущений, а волосы при этом остаются здоровыми, блестящими и не выпадают, то нет необходимости срочно менять уход.';
        _recommendation =
            "Рекомендуем: У вас нормальная кожа головы без выраженных проблем. В этом случае вы можете спокойно продолжать пользоваться тем, что вам подходит — но важно периодически оценивать состояние кожи головы и волос, чтобы вовремя заметить возможные изменения и при необходимости скорректировать уход.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = ['La Roche-Posay Kerium'];
      }
      if (_scalpType == 'Комбинированная' && _selectedProblem == 'Выпадение') {
        _problem =
            'У вас комбинированная кожа головы и наблюдается выпадение волос. Чтобы эффективно остановить выпадение, важно подобрать уход, который укрепляет корни, улучшает кровообращение, но при этом не усиливает жирность и не сушит длину.';
        _recommendation =
            "Рекомендуем: 2–3 раза в неделю используйте шампунь, после мытья наносите ампулы или тоники против выпадения на кожу головы, пилинг кожи головы 1 раз в неделю.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'La Roche-Posay Kerium DS',
          'Lador Hydro LPP',
          'System 4 Serum',
        ];
      }
      if (_scalpType == 'Комбинированная' && _selectedProblem == 'Перхоть') {
        _problem =
            'У вас комбинированная кожа головы с перхотью. Текущий уход может усиливать жирность у корней, пересушивать длину и не устранять основную причину перхоти. Требуется комплексный подход с мягким лечением и деликатным уходом.';
        _recommendation =
            "Рекомендуем: 2–3 раза в неделю используйте шампунь, 1 раз в неделю — пилинг кожи головы, тоник после мытья для балансировки кожи головы.";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'Vichy Dercos Anti-Dandruff',
          'CP-1 Scalp Scaler',
          'CP-1 Scalp Tonic',
        ];
      }
      if (_scalpType == 'Комбинированная' && _selectedProblem == 'Зуд') {
        _problem = '';
        _recommendation = "Рекомендуем: ";
        // Добавляем сюда названия шампуней, которые мы будем искать в базе
        _shampoos = [
          'La Roche-Posay Kerium',
          'Estel Curex Therapy',
          'Kerastase Nutritive 8H Magic Night Serum',
        ];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getRecommendation(); // Вызываем рекомендацию при старте экрана
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Проверка средств на совместимость'),
        backgroundColor: Color.fromARGB(255, 65, 195, 255),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Выбор типа кожи головы
              SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _scalpType,
                decoration: InputDecoration(
                  labelText: 'Тип кожи головы',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true, // Центрирует выпадающий список
                onChanged: (value) {
                  setState(() {
                    _scalpType = value;
                  });
                },
                items:
                    _scalpTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
              ),
              SizedBox(height: 20),

              // Выбор проблемы, которую нужно решить
              DropdownButtonFormField<String>(
                value: _selectedProblem,
                decoration: InputDecoration(
                  labelText: 'Проблемы, которые нужно решить',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true, // Центрирует выпадающий список
                onChanged: (value) {
                  setState(() {
                    _selectedProblem = value;
                  });
                },
                items:
                    _problems.map((String problem) {
                      return DropdownMenuItem<String>(
                        value: problem,
                        child: Text(problem),
                      );
                    }).toList(),
              ),
              SizedBox(height: 20),

              // Ввод используемых брендов
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Используемые бренды (через запятую)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите используемые бренды';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _brands = value;
                  });
                },
              ),
              SizedBox(height: 20),
              if (showImage)
                Image.asset('assets/check_hair.png', width: 450, height: 380),
              // Кнопка для получения рекомендации
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _getRecommendation();
                    // Переход на экран с рекомендациями
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecommendationScreen(
                              recommendation: _recommendation,
                              scalpType: _scalpType!,
                              selectedProblem: _selectedProblem!,
                              brands: _brands,
                              problem: _problem,
                              shampoos: _shampoos,
                            ),
                      ),
                    );
                  }
                },
                child: Text('Получить рекомендацию'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendationScreen extends StatelessWidget {
  final String recommendation;
  final String scalpType;
  final String selectedProblem;
  final String brands;
  final String problem;
  final List<String> shampoos;

  const RecommendationScreen({
    super.key,
    required this.recommendation,
    required this.scalpType,
    required this.selectedProblem,
    required this.brands,
    required this.problem,
    required this.shampoos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подбор уходовых средств'),
        backgroundColor: Color.fromARGB(255, 65, 195, 255),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Выводим выбранные данные
              _buildDataRow('Тип кожи головы:', scalpType),
              _buildDataRow('Проблемы:', selectedProblem),
              _buildDataRow('Используемые бренды:', brands),
              Divider(),
              // Информация о бренде
              if (brands.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Используемые средства:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$brands: ${_getBrandInfo(brands)}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              // Разделитель
              Divider(color: Colors.grey.shade400, thickness: 1.2, height: 30),

              // Тело рекомендации
              Text(
                'Вывод рекомендаций:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                problem,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                recommendation,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 10),

              // Разделитель
              Divider(color: Colors.grey.shade400, thickness: 1.2, height: 30),

              // Выводим подходящие шампуни из Firebase
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('shampooHair')
                    .snapshots()
                    .map(
                      (snapshot) =>
                          snapshot.docs.map((doc) {
                            return {
                              'name': doc['name'],
                              'photoUrl': doc['photoUrl'],
                            };
                          }).toList(),
                    ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка загрузки данных'));
                  }

                  final shampooList = snapshot.data ?? [];

                  // Отображаем только те шампуни, которые есть в рекомендациях
                  final recommendedShampoos =
                      shampooList
                          .where(
                            (shampoo) => shampoos.any(
                              (shampooName) => shampoo['name'] == shampooName,
                            ),
                          )
                          .toList();

                  return recommendedShampoos.isEmpty
                      ? Center(child: Text('Шампуни не найдены'))
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            recommendedShampoos.map((shampoo) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          shampoo['photoUrl'],
                                          width: 150,
                                          height: 100,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          shampoo['name'],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                ],
                              );
                            }).toList(),
                      );
                },
              ),
              SizedBox(height: 20),

              // Разделитель

              // Кнопка для возврата на предыдущий экран
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Возврат на предыдущий экран
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Назад'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 65, 195, 255),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Функция для отображения строк данных
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Функция для получения информации о бренде
  String _getBrandInfo(String brand) {
    Map<String, String> brandInfo = {
      'Fructis':
          'Fructis - содержит силиконы и плотные ПАВы, утяжеляют волосы при жирной коже головы.',
      'Pantene':
          'Pantene - шампунь, содержащий силиконы, утяжеляет волосы, делает их менее объемными.',
      'Head & Shoulders':
          'Head & Shoulders - эффективно борется с перхотью, но может пересушивать кожу головы.',
      'Clear':
          'Clear - содержит сульфаты, спирты и дешёвые силиконы, которые могут пересушивать кожу головы и нарушать водный баланс волос.',
      'Dove':
          'Dove - содержит сульфаты, спирты и дешёвые силиконы, которые могут пересушивать кожу головы и нарушать водный баланс волос.',
      'Syoss':
          'Syoss - содержит силиконы, плотные ПАВы и отдушки, которые могут утяжелять волосы и раздражать кожу головы при длительном применении.',
      'Herbal Essences':
          'Herbal Essences - содержит силиконы, плотные ПАВы и отдушки, которые могут утяжелять волосы и раздражать кожу головы при длительном применении.',
      'Natura Siberica':
          'Natura Siberica - хорошая база, но иногда может пересушивать концы.',
      'Gliss Kur':
          'Gliss Kur - содержит силиконы, плотные кондиционирующие компоненты и сульфаты, которые при комбинированной коже головы могут усиливать жирность у корней и при этом не решать проблему сухости и ломкости на длине.',
      'Elseve':
          'Elseve - содержит силиконы, сульфаты и плотные плёнкообразующие компоненты. Может визуально улучшать состояние волос, но не восстанавливают структуру, а при регулярном применении даже снижают эластичность и влагу внутри волоса.',
      'Schauma':
          'Schauma - содержит силиконы, сульфаты и плотные плёнкообразующие компоненты. Может визуально улучшать состояние волос, но не восстанавливают структуру, а при регулярном применении даже снижают эластичность и влагу внутри волоса.',
      'Lador':
          'Средства Lador, особенно Lador TripleX 3, Keratin Power Glue и шампуни с коллагеном, известны своим восстанавливающим эффектом. Продукция содержит аминокислоты, кератин и белки шелка, которые укрепляют волосы и придают им гладкость.',
      'Klorane':
          'Французский бренд с растительными экстрактами, такими как хинин, овёс, крапива, манго. Особенно известен шампунь с хинином для укрепления волос.',
      'System 4':
          'Профессиональная лечебная серия от Sim Sensitive (Финляндия), особенно эффективна при себорее, перхоти и выпадении волос. Комплексный подход (шампунь, сыворотка, маска) помогает справиться с проблемами кожи головы.',
      'Librederm':
          'Российский бренд, отличающийся аптечным качеством. Шампуни Librederm с цинком, дегтярные и с алоэ вера подходят для чувствительной кожи головы.',
      'Bioderma':
          'Марка аптечной косметики с дерматологическим уклоном. Серия Node DS+ особенно эффективна при жирной себорее и зуде. Продукты без агрессивных ПАВов.',
      'La Roche-Posay':
          'Известна своими гипоаллергенными составами и термальной водой. Шампуни Kerium DS отлично работают при чувствительной коже и перхоти.',
      'Ducray':
          'Аптечный бренд с клинически доказанной эффективностью. Ducray Anaphase+ стимулирует рост волос, а серия Kelual помогает при себорейном дерматите.',
      'Vichy':
          'В особенности серия Dercos — признанный лидер в борьбе с выпадением волос. Шампуни с аминексилом, минералами и витаминами укрепляют волосы и улучшают состояние кожи головы.',
      'Dercos':
          'Dercos Aminexil, Dercos Anti-Dandruff, Dercos Nutri Protein — специализированные средства для решения конкретных проблем: от выпадения, перхоти, до восстановления ломких волос.',
    };

    return brandInfo[brand] ?? 'Информация о бренде не найдена';
  }
}
