import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  TaskDetailScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Детали задачи')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Нет доступных задач'));
          }

          var tasks = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                bool isCompleted = task['completed'] ?? false;

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  leading:
                      task['imageURL'] != null
                          ? Image.network(
                            task['imageURL'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                          : Icon(Icons.task, size: 40, color: Colors.grey),
                  title: Text(
                    task['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(task['description']),
                  trailing: GestureDetector(
                    onTap: () async {
                      // Отметить задачу как выполненную
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(task.id)
                          .update({'completed': !isCompleted});

                      // Показываем сообщение об успешном обновлении
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isCompleted
                                ? 'Задача не выполнена'
                                : 'Задача выполнена',
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.circle,
                      color: isCompleted ? Colors.green : Colors.grey,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
