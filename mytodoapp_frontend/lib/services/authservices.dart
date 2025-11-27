import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodoapp_frontend/model/user_model.dart';

class Authservices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> signUpUser(UserModel user) async {
    UserCredential userCredentials = await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );

    if (userCredentials.user != null) {
      await firestore.collection('Users').doc(userCredentials.user!.uid).set({
        user.toJason(),
      });
    } else {
      print('user is already registered');
    }
  }
}
