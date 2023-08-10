import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/domain/entities/to_do_item.dart';
import 'package:todo_list_provider/presentation/components/edit_to_do_item_dialog.dart';
import 'package:todo_list_provider/presentation/notifier_providers/to_do_notifier_provider.dart';

class ToDoListView extends StatefulWidget {
  final bool isCompletedTab;

  const ToDoListView({
    required this.isCompletedTab,
    Key? key,
  }) : super(key: key);

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {
  late ToDoNotifierProvider provider;
  late bool isCompletedTab;

  @override
  void initState() {
    super.initState();
    provider = context.read();
    isCompletedTab = widget.isCompletedTab;
  }

  @override
  Widget build(BuildContext context) {
    final ToDoState state = context.select<ToDoNotifierProvider, ToDoState>(getToDoState);
    final ToDoStatus status = state.status;
    if (status == ToDoStatus.initial) {
      return const CircularProgressIndicator();
    }

    final List<ToDoItem> toDoItems = state.items;
    final List<ToDoItem> filteredItems = toDoItems.where((ToDoItem item) => item.isComplete == isCompletedTab).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: filteredItems.length,
      itemBuilder: (BuildContext context, int index) {
        return showToDoItems(filteredItems, index);
      },
    );
  }

  ToDoState getToDoState(ToDoNotifierProvider provider) {
    return provider.state;
  }

  Widget showToDoItems(List<ToDoItem> toDoItems, int index) {
    final ToDoItem toDoItem = toDoItems[index];
    return Container(
      child: Card(
        child: InkWell(
          onTap: () => provider.changeCompletionOfToDoItem(toDoItem),
          child: Row(
            children: <Widget>[
              radioButton(toDoItem),
              cardText(toDoItem),
              spacer(),
              editButton(toDoItem),
              deleteButton(toDoItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioButton(ToDoItem toDoItem) {
    return Radio<bool>(
      value: toDoItem.isComplete,
      groupValue: true,
      onChanged: (_) => provider.changeCompletionOfToDoItem(toDoItem),
      toggleable: true,
    );
  }

  Widget cardText(ToDoItem toDoItem) {
    return Text(
      toDoItem.text,
      style: TextStyle(
        decoration: isCompletedTab ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  Widget spacer() {
    return const Expanded(
      child: SizedBox(),
    );
  }

  Widget editButton(ToDoItem toDoItem) {
    return IconButton(
      onPressed: () => alertDialog(toDoItem),
      icon: const Icon(
        Icons.edit,
      ),
    );
  }

  Widget deleteButton(ToDoItem toDoItem) {
    return IconButton(
      onPressed: () => provider.removeToDoItem(toDoItem),
      icon: const Icon(
        Icons.delete,
      ),
    );
  }

  void alertDialog(ToDoItem toDoItem) {
    final EditToDoItemDialog dialog = EditToDoItemDialog(
      toDoItem: toDoItem,
      context: context,
    );
    dialog.showEditDialog();
  }
}
