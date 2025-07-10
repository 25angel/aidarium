import 'package:flutter/material.dart';

class ProductCompatibilityScreen extends StatefulWidget {
  @override
  _ProductCompatibilityScreenState createState() =>
      _ProductCompatibilityScreenState();
}

class _ProductCompatibilityScreenState
    extends State<ProductCompatibilityScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedProduct1;
  String? selectedProduct2;
  String compatibilityResult = '';

  final List<String> products = [
    'Шампунь для волос',
    'Кондиционер',
    'Маска для волос',
    'Омолаживающий крем для лица',
    'Сыворотка для лица',
  ];

  // Логика проверки совместимости продуктов
  void checkCompatibility() {
    setState(() {
      if (selectedProduct1 == selectedProduct2) {
        compatibilityResult = 'Эти продукты несовместимы.';
      } else {
        compatibilityResult = 'Продукты совместимы.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Проверка совместимости уходовых средств'),
        backgroundColor: Color(0xFF41C3FF),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Выберите два продукта для проверки их совместимости:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Формы для выбора продуктов
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedProduct1,
                    decoration: InputDecoration(
                      labelText: 'Продукт 1',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct1 = value;
                      });
                    },
                    items:
                        products
                            .map(
                              (product) => DropdownMenuItem<String>(
                                value: product,
                                child: Text(product),
                              ),
                            )
                            .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Пожалуйста, выберите продукт';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: selectedProduct2,
                    decoration: InputDecoration(
                      labelText: 'Продукт 2',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct2 = value;
                      });
                    },
                    items:
                        products
                            .map(
                              (product) => DropdownMenuItem<String>(
                                value: product,
                                child: Text(product),
                              ),
                            )
                            .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Пожалуйста, выберите продукт';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Кнопка для проверки совместимости
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  checkCompatibility();
                }
              },
              child: Text('Проверить совместимость'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF41C3FF),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),

            // Результат совместимости
            if (compatibilityResult.isNotEmpty)
              Text(
                compatibilityResult,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
