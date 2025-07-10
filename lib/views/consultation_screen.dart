import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultationScreen extends StatelessWidget {
  final String whatsappNumber = '77769185286';

  void _launchWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Не удалось открыть $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Светлый фон для всего экрана
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Консультация',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConsultationInfo(context),
            SizedBox(height: 20),
            Text(
              'Консультанты',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSpecialistCard(
              context,
              title: 'Трихолог',
              description:
                  'Поможет с диагностикой и лечением волос и кожи головы',
            ),
            _buildSpecialistCard(
              context,
              title: 'Дерматолог',
              description: 'Поможет с проблемами кожи головы',
            ),
            _buildSpecialistCard(
              context,
              title: 'Диетолог',
              description: 'Подберёт питание, полезное для ваших волос',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Онлайн-консультация',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Запишитесь на онлайн-консультацию: сэкономьте время и получите ответы от доктора в комфортных условиях.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Доктор также предложит вам план лечения и рекомендации по анализам.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'У нас в 4 раза дешевле, чем в клиниках оффлайн.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              _showConsultationDetails(context);
            },
            child: Text(
              'Как проходит консультация?',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () => _launchWhatsApp(whatsappNumber),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showConsultationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Онлайн-консультации',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Онлайн-консультации проще, удобнее и экономят ваше время.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildConsultationStep(
                '1. Вы выбираете направление, по которому вам нужна помощь врача.',
              ),
              _buildConsultationStep(
                '2. Описываете ваши жалобы и беспокойства.',
              ),
              _buildConsultationStep('3. Выбираете время и дату.'),
              _buildConsultationStep('4. Оплачиваете консультацию.'),
              _buildConsultationStep(
                '5. Мы подберем вам подходящего врача по профилю и опыту.',
              ),
              _buildConsultationStep(
                '6. Консультация будет в зуме онлайн, мы напомним о ней персональными уведомлениями.',
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Понятно'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsultationStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}
