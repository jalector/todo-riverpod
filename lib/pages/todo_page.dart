import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/todo_provider.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/add-todo'),
          ),
        ],
      ),
      body: todos.isEmpty ? _empty : _itemList(ref),
    );
  }

  Widget get _empty {
    return const Center(
      child: Text(
        'No todos yet. Tap the + button to add one!',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _itemList(WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          tileColor: Colors.grey[300],
          title: Text(todo.text),
          subtitle: Text(
            'Created: ${todo.createdAt.toString().split('.')[0]}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              ref.read(todoProvider.notifier).removeTodo(todo.id);
            },
          ),
        );
      },
    );
  }
}
