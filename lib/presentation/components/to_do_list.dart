import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/presentation/components/to_do_list_app_bar.dart';
import 'package:todo_list_provider/presentation/components/to_do_list_tab_bar_view.dart';
import 'package:todo_list_provider/presentation/notifier_providers/to_do_notifier_provider.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const ToDoListAppBar(),
        body: ChangeNotifierProvider<ToDoNotifierProvider>(
          create: (_) => ToDoNotifierProvider(),
          child: const ToDoListTabBarView(),
        ),
      ),
    );
  }
}
