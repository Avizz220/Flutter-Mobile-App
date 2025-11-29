import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodoapp_frontend/model/todo_model.dart';
import 'package:mytodoapp_frontend/services/notification_services_db.dart';

class TodoServices {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final notificationServices = NotificationServices();

  Future<void> addTodoDatabase(TodoModel todo) async {
    try {
      await firestore.collection('Todos').doc(todo.todoID).set(todo.toJson());

      await notificationServices.createNotification(
        title: 'New Task Created',
        message: 'You have created a new task: "${todo.title}"',
        type: 'task_created',
        taskID: todo.todoID,
      );
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TodoModel>> getTodos() {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Stream.value([]);
      }

      return firestore
          .collection('Todos')
          .where('userID', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
            final todos =
                snapshot.docs.map((doc) {
                  final data = doc.data();
                  return TodoModel(
                    todoID: data['todoID'] ?? '',
                    title: data['title'] ?? '',
                    description: data['description'] ?? '',
                    userID: data['userID'] ?? '',
                    isCompleted: data['isCompleted'] ?? false,
                    createdAt: DateTime.parse(
                      data['createdAt'] ?? DateTime.now().toIso8601String(),
                    ),
                  );
                }).toList();

            todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return todos;
          });
    } catch (e) {
      return Stream.value([]);
    }
  }

  Future<void> deleteTodo(String todoID) async {
    try {
      await firestore.collection('Todos').doc(todoID).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      await firestore
          .collection('Todos')
          .doc(todo.todoID)
          .update(todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTodoComplete(String todoID, bool currentStatus) async {
    try {
      await firestore.collection('Todos').doc(todoID).update({
        'isCompleted': !currentStatus,
      });

      if (currentStatus == false) {
        final taskDoc = await firestore.collection('Todos').doc(todoID).get();
        final taskTitle = taskDoc.data()?['title'] ?? 'Task';

        await notificationServices.createNotification(
          title: 'Task Completed',
          message: 'Well done! You have completed: "$taskTitle"',
          type: 'task_completed',
          taskID: todoID,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
