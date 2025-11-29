import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodoapp_frontend/model/notification_model.dart';

class NotificationServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createNotification({
    required String title,
    required String message,
    required String type,
    String? taskID,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) return;

      final notificationID = DateTime.now().millisecondsSinceEpoch.toString();
      final notification = NotificationModel(
        notificationID: notificationID,
        userID: user.uid,
        title: title,
        message: message,
        type: type,
        isRead: false,
        createdAt: DateTime.now(),
        taskID: taskID,
      );

      await firestore
          .collection('Notifications')
          .doc(notificationID)
          .set(notification.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<NotificationModel>> getNotifications() {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Stream.value([]);
      }

      return firestore
          .collection('Notifications')
          .where('userID', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        final notifications = snapshot.docs.map((doc) {
          final data = doc.data();
          return NotificationModel.fromJson(data);
        }).toList();

        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return notifications;
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  Future<void> markAsRead(String notificationID) async {
    try {
      await firestore.collection('Notifications').doc(notificationID).update({
        'isRead': true,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final user = auth.currentUser;
      if (user == null) return;

      final snapshot = await firestore
          .collection('Notifications')
          .where('userID', isEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final user = auth.currentUser;
      if (user == null) return 0;

      final snapshot = await firestore
          .collection('Notifications')
          .where('userID', isEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Stream<int> getUnreadCountStream() {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Stream.value(0);
      }

      return firestore
          .collection('Notifications')
          .where('userID', isEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      return Stream.value(0);
    }
  }
}
