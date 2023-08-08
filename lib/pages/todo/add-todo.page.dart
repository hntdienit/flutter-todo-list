// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_todo_list/helpers/message.helper.dart';
import 'package:flutter_todo_list/services/todos.service.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController tilleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];

      tilleController.text = title;
      descController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(50),
        children: [
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: tilleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: isEdit ? handleEdit : handleSubmit,
              child: Text(isEdit ? 'Update' : 'Submit'))
        ],
      ),
    );
  }

  Future<void> handleSubmit() async {
    final isSuccess = await TodosService.createTodo(body);
    if (isSuccess) {
      tilleController.text = '';
      descController.text = '';

      showMessageCallAPI(context,
          message: 'Create todo successfully', success: true);
    }

    if (!isSuccess) {
      showMessageCallAPI(context,
          message: 'Create todo failed', success: false);
    }
  }

  Future<void> handleEdit() async {
    final todo = widget.todo;

    if (todo == null) {
      return;
    }

    final id = todo['_id'].toString();

    final isSuccess = await TodosService.updateTodo(id, body);

    if (isSuccess) {
      showMessageCallAPI(context,
          message: 'Update todo successfully', success: true);

      if (!isSuccess) {
        showMessageCallAPI(context,
            message: 'Update todo failed', success: false);
      }
    }
  }

  Map get body {
    final title = tilleController.text;
    final desc = descController.text;

    return {"title": title, "description": desc, "is_completed": false};
  }
}
