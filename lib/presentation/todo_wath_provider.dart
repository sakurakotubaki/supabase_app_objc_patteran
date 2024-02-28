import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app_objc_patteran/application/todo_repository.dart';
import 'package:supabase_app_objc_patteran/infrastructure/todo_stream.dart';

class TodoWatchProvider extends ConsumerWidget {
  const TodoWatchProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoStreamProvider);
    final title = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Watch Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                hintText: 'Enter your todo',
              ),
            ),
            const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(todoRepositoryImplProvider).create(title.text);
                },
                child: const Text('Add'),
              ),
            const SizedBox(height: 20),
            todoList.when(
              data: (todos) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${todos[index]['title']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await ref.read(todoRepositoryImplProvider).delete(todos[index]);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ],
        )
      ),);
  }
}
