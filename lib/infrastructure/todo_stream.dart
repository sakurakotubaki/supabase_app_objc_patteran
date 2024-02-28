import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_app_objc_patteran/application/todo_repository.dart';
part 'todo_stream.g.dart';

@riverpod
Stream<List<Map<String, dynamic>>> todoStream(TodoStreamRef ref) {
  return ref.watch(todoRepositoryImplProvider).watch();
}