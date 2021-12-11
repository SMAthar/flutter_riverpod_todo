import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Todo {
  Todo({
    required this.id,
    required this.description,
    this.isCompleted = false,
  });
  final String id;
  final String description;
  final bool isCompleted;

  @override
  String toString() {
    return 'Todo (description:$description is completed:$isCompleted)';
  }
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(id: _uuid.v4(), description: description),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: todo.description,
            isCompleted: !todo.isCompleted,
          )
        else
          todo,
    ];
  }

  void remove(Todo rTodo) {
    state = state.where((todo) => todo.id != rTodo.id).toList();
  }
}
