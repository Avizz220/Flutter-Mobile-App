part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class TodoAddedEvent extends TodoEvent {
  final TodoModel todoModel;

  TodoAddedEvent({required this.todoModel});
}
