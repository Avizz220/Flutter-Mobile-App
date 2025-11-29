import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytodoapp_frontend/model/user_model.dart';

class Authservices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> signUpUser(UserModel user) async {
    try {
      UserCredential userCredentials = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (userCredentials.user != null) {
        UserModel finalUser = UserModel(
          userID: userCredentials.user!.uid,
          name: user.name,
          email: user.email,
          password: user.password,
          fcmToken: user.fcmToken,
        );
        
        await firestore.collection('Users').doc(userCredentials.user!.uid).set(
          finalUser.toJason(),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
