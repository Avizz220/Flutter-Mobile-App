part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final UserModel userModel;
  SignUpEvent({required this.userModel});
}
