import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod_todo/todo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'todo.dart';

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList([
    Todo(id: 'Todo-0', description: "Good Morning"),
    Todo(id: 'Todo-1', description: "Code Some Cool stuff"),
    Todo(id: 'Todo-3', description: "Code Again"),
  ]);
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final todoController = useTextEditingController();

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Center(
                  child: Text("Todo App",
                      style: Theme.of(context).textTheme.headline2),
                ),
                const SizedBox(height: 10),
                const Divider(height: 0),
                const SizedBox(height: 30),
                TextField(
                  controller: todoController,
                  decoration: const InputDecoration(labelText: "What next?"),
                  onSubmitted: (value) {
                    ref.read(todoListProvider.notifier).add(value);
                    todoController.clear();
                  },
                ),
                for (var i = 0; i < todos.length; i++) ...[
                  if (i > 0) const Divider(height: 0),
                  ListTile(
                    leading: Checkbox(
                      value: todos[i].isCompleted,
                      onChanged: (bool? value) {
                        ref.read(todoListProvider.notifier).toggle(todos[i].id);
                      },
                    ),
                    title: Text(
                      todos[i].description,
                      style: TextStyle(
                          decoration: todos[i].isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(todoListProvider.notifier).remove(todos[i]);
                      },
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
