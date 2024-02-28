import 'package:flutter/material.dart';

import '../application/todo_repository.dart';

class TodoWatchView extends StatefulWidget {
  const TodoWatchView({super.key});

  @override
  State<TodoWatchView> createState() => _TodoWatchViewState();
}

class _TodoWatchViewState extends State<TodoWatchView> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Watch View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
              ),
            ),
            ElevatedButton(onPressed: () async {
              await TodoRepositoryImpl().create(titleController.text);
            }, child: const Text('追加')),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: TodoRepositoryImpl().watch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('エラーが発生しました: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Text('データがありません');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return ListTile(
                        title: Text('${data['title']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await TodoRepositoryImpl().delete(data);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
