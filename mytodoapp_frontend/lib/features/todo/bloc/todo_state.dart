part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

class TodoAddInProgressState extends TodoState {}

class TodoAddSuccessState extends TodoState {}

class TodoAddErrorState extends TodoState {
  final String error;

  TodoAddErrorState({required this.error});
}


