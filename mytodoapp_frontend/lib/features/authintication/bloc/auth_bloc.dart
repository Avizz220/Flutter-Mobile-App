import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:mytodoapp_frontend/model/user_model.dart';
import 'package:mytodoapp_frontend/services/authservices.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Authservices authservices = Authservices();
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(signupEvent);
  }

  Future<void> signupEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(SignupInProgressState());
      await authservices.signUpUser(event.userModel);
      emit(SignupSuccessState());
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(SignupErrorState(error: 'Email already in use'));
      } else if (e.code == 'invalid-email') {
        emit(SignupErrorState(error: 'Invalid email format'));
      } else if (e.code == 'operation-not-allowed') {
        emit(SignupErrorState(error: 'Operation not allowed'));
      } else if (e.code == 'weak-password') {
        emit(SignupErrorState(error: 'Password is too weak'));
      } else {
        emit(SignupErrorState(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(SignupErrorState(error: 'An unexpected error occurred'));
    }
  }
}
