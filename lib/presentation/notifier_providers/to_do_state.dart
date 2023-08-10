part of 'to_do_notifier_provider.dart';

enum ToDoStatus {
  initial,
  loaded,
}

@immutable
class ToDoState extends Equatable {
  final ToDoStatus status;
  final List<ToDoItem> items;

  const ToDoState({
    required this.status,
    this.items = const <ToDoItem>[],
  });

  ToDoState copyWith({
    ToDoStatus? status,
    List<ToDoItem>? items,
  }) {
    return ToDoState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => <Object>[
        UniqueKey(),
        status,
        items,
      ];
}
