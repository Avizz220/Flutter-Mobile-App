import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodoapp_frontend/model/event_model.dart';

class EventServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addEvent(EventModel event) async {
    try {
      await firestore.collection('Events').doc(event.eventID).set(event.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<EventModel>> getEvents() {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Stream.value([]);
      }

      return firestore
          .collection('Events')
          .where('userID', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        final events = snapshot.docs.map((doc) {
          final data = doc.data();
          return EventModel.fromJson(data);
        }).toList();

        events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
        return events;
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  Future<List<EventModel>> getEventsByDate(DateTime date) async {
    try {
      final user = auth.currentUser;
      if (user == null) return [];

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await firestore
          .collection('Events')
          .where('userID', isEqualTo: user.uid)
          .where('eventDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('eventDate', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteEvent(String eventID) async {
    try {
      await firestore.collection('Events').doc(eventID).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEvent(EventModel event) async {
    try {
      await firestore.collection('Events').doc(event.eventID).update(event.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel?> getEventByTaskId(String taskID) async {
    try {
      final user = auth.currentUser;
      if (user == null) return null;

      final snapshot = await firestore
          .collection('Events')
          .where('userID', isEqualTo: user.uid)
          .where('taskID', isEqualTo: taskID)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return EventModel.fromJson(snapshot.docs.first.data());
    } catch (e) {
      return null;
    }
  }
}
