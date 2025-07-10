import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bool showImage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задачи')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Задачи на сегодня
            if (showImage)
              Image.asset('assets/tasks_photo.png', width: 350, height: 150),

            _buildCategorySection('Задачи на сегодня', 'daily', context),
            // Задачи на неделю
            _buildCategorySection('Задачи на эту неделю', 'weekly', context),
            // Задачи на месяц
            _buildCategorySection('Задачи на этот месяц', 'monthly', context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String categoryName,
    String categoryType,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream:
              _firestore
                  .collection('tasks')
                  .where('category', isEqualTo: categoryType)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('Нет доступных задач для этой категории');
            }

            var tasks = snapshot.data!.docs;
            int completedTasks =
                tasks.where((task) => task['completed'] == true).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Прогресс выполнения задач
                LinearProgressIndicator(
                  value: tasks.isNotEmpty ? completedTasks / tasks.length : 0.0,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Text(
                  '$completedTasks / ${tasks.length} задач выполнено',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                // Кнопка для перехода на TaskDetailScreen при наличии задач
                if (tasks.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      // Переход на экран с деталями задачи
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TaskDetailScreen(
                                taskId: tasks[0].id, // Переход к первой задаче
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Перейти к задачам',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
