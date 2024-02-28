import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo_repository.dart';
part 'todo_async_notifier.g.dart';

@riverpod
class TodoAsyncNotifier extends _$TodoAsyncNotifier {

  @override
  FutureOr<List<Map<String, dynamic>>> build() {
    return fetch();
  }

  Future<List<Map<String, dynamic>>> fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(todoRepositoryImplProvider).fetch();
    });
    return state.maybeWhen(
      data: (data) => data,// 値があるときはその値を返す
      orElse: () => [],// 値がないときは空のリストを返す
    );
  }
}