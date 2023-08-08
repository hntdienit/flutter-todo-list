import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/todo/add-todo.page.dart';
import 'package:flutter_todo_list/services/todos.service.dart';
import 'package:flutter_todo_list/widgets/todo/todo-card.widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No todo item',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                updateIndex(oldIndex, newIndex);
              },
              children: [
                for (int i = 0; i < items.length; i++)
                  Padding(
                    key: ValueKey(items[i]),
                    padding: const EdgeInsets.all(5),
                    child: TodoCard(
                      index: i,
                      item: items[i] as Map,
                      deleteById: deleteById,
                      navigateEdit: navigateTodoEditPage,
                    ),
                  ),
              ],
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateTodoAddPage, label: const Text('Add todo')),
    );
  }

  void updateIndex(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  Future<void> navigateTodoAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateTodoEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodosService.deleteById(id);

    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }

    if (!isSuccess) {
      // show error
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodosService.fetchTodo();

    if (response != null) {
      setState(() {
        items = response;
      });
    }

    if (response == null) {
      // show error
    }

    setState(() {
      isLoading = false;
    });
  }
}
