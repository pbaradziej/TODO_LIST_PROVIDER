import 'package:todo_list_provider/domain/entities/to_do_item.dart';

abstract class ToDoRepository {
  Future<List<ToDoItem>> getToDoItems();

  Future<void> setToDoItems(List<ToDoItem> toDoItems);
}
