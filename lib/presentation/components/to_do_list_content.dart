import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/domain/entities/to_do_item.dart';
import 'package:todo_list_provider/presentation/components/to_do_list_view.dart';
import 'package:todo_list_provider/presentation/notifier_providers/to_do_notifier_provider.dart';

class ToDoListContent extends StatefulWidget {
  const ToDoListContent({Key? key}) : super(key: key);

  @override
  State<ToDoListContent> createState() => _ToDoListContentState();
}

class _ToDoListContentState extends State<ToDoListContent> {
  late ToDoNotifierProvider provider;
  late TextEditingController adderToDoController;

  @override
  void initState() {
    super.initState();
    provider = context.read();
    adderToDoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        adderTextField(),
        const SizedBox(height: 10),
        const ToDoListView(
          isCompletedTab: false,
        ),
      ],
    );
  }

  Widget adderTextField() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: adderToDoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input text',
            ),
            onSubmitted: (_) {
              final String text = adderToDoController.text;
              final ToDoItem toDoItem = ToDoItem(text: text);
              provider.addToDoItem(toDoItem);
              adderToDoController.clear();
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final String text = adderToDoController.text;
            final ToDoItem toDoItem = ToDoItem(text: text);
            provider.addToDoItem(toDoItem);
            adderToDoController.clear();
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
