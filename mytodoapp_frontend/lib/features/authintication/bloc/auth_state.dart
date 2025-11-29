part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

//3 total states

class SignupInProgressState extends AuthState {}

class SignupSuccessState extends AuthState {}

class SignupErrorState extends AuthState {
  final String error;

  SignupErrorState({required this.error});
}

class SignInProgressState extends AuthState {}

class SignInSuccessState extends AuthState {}

class SignInErrorState extends AuthState {
  final String error;

  SignInErrorState({required this.error});
}
