import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/todo_repository.dart';
import '../application/usecase/todo_async_notifier.dart';

class TodoAsyncProvider extends ConsumerWidget {
  const TodoAsyncProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoAsyncNotifierProvider);
    final titleController = TextEditingController();

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Todo Async Provider'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Enter your todo',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await ref.read(todoRepositoryImplProvider).create(titleController.text);
              ref.invalidate(todoAsyncNotifierProvider);
            },
            child: const Text('Add'),
          ),
          const SizedBox(height: 20),
          todoAsync.when(
            data: (data) {
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${data[index]['title']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await ref.read(todoRepositoryImplProvider).delete(data[index]);
                          // FutureProviderと同じように、invalidateで強制的にデータを更新
                          ref.invalidate(todoAsyncNotifierProvider);
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
      ),
    );
  }
}
