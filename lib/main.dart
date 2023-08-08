import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/todo/todo.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
    );
  }
}
