import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/domain/entities/to_do_item.dart';
import 'package:todo_list_provider/domain/usecases/to_do_actions.dart';

part 'to_do_state.dart';

class ToDoNotifierProvider extends ChangeNotifier {
  final ToDoActions toDoActions;
  late ToDoState _state;

  ToDoNotifierProvider({
    ToDoActions? toDoActions,
  })  : toDoActions = toDoActions ?? ToDoActions(),
        _state = const ToDoState(status: ToDoStatus.initial);

  ToDoState get state => _state;

  List<ToDoItem> get _toDoItems => _state.items;

  Future<void> initializeToDoItems() async {
    final List<ToDoItem> items = await toDoActions.getToDoItems();
    _emitState(items: items);
  }

  Future<void> addToDoItem(ToDoItem item) async {
    _toDoItems.add(item);
    await toDoActions.setToDoItems(_toDoItems);
    _emitState();
  }

  Future<void> editToDoItem(String guid, String updatedText) async {
    final int toDoItemIndex = _toDoItems.indexWhere((ToDoItem item) => item.guid == guid);
    final ToDoItem toDoItem = _toDoItems.elementAt(toDoItemIndex);
    final ToDoItem updatedToDoItem = toDoItem.copyWith(text: updatedText);
    _toDoItems[toDoItemIndex] = updatedToDoItem;
    await toDoActions.setToDoItems(_toDoItems);
    _emitState();
  }

  Future<void> removeToDoItem(ToDoItem item) async {
    _toDoItems.remove(item);
    await toDoActions.setToDoItems(_toDoItems);
    _emitState();
  }

  Future<void> changeCompletionOfToDoItem(ToDoItem item) async {
    final int toDoItemIndex = _toDoItems.indexOf(item);
    final ToDoItem updatedToDoItem = item.copyWith(isComplete: !item.isComplete);
    _toDoItems[toDoItemIndex] = updatedToDoItem;
    await toDoActions.setToDoItems(_toDoItems);
    _emitState();
  }

  void _emitState({
    List<ToDoItem>? items,
  }) {
    _state = _state.copyWith(
      items: items ?? _toDoItems,
      status: ToDoStatus.loaded,
    );
    notifyListeners();
  }
}
