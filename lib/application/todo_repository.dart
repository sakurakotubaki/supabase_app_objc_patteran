import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'base_repository.dart';
part 'todo_repository.g.dart';

// Supabaseに、create, select, deleteを実行するためのinterfaceを作成します。
abstract interface class TodoRepository {
  Stream<List<Map<String, dynamic>>> watch();
  Future<List<Map<String, dynamic>>> fetch();
  Future<void> create(String title);
  Future<void> delete(Map<String, dynamic> data);
}

// flutter pub run build_runner watch --delete-conflicting-outputs
@Riverpod(keepAlive: true)
TodoRepositoryImpl todoRepositoryImpl(TodoRepositoryImplRef ref) {
  return TodoRepositoryImpl();
}

// BaseRepositoryImplを継承して、TodoRepositoryを実装します。
// スーパークラスであるinterfaceを継承して、サブクラスでメソッドを実装します。
class TodoRepositoryImpl extends BaseRepositoryImpl implements TodoRepository {
  // ベースクラスのゲッターを上書きして、テーブル名とプライマリーキーを代入して、このクラス内で
  // 使えるようにします。

  // todosテーブルの名前を取得
  @override
  String get tableName => 'todos';

  // todosテーブルのプライマリーキーを取得
  @override
  String get primaryKey => 'id';

  // createt
  @override
  Future<void> create(String title) async {
    await supabase.client.from(tableName).insert({'title': title});
  }

  // リアルタイムにデータを取得するためのwatchメソッドを実装します。
  @override
  Stream<List<Map<String, dynamic>>> watch() {
    return supabase.client.from(tableName).stream(primaryKey: [primaryKey]).map((response) {
      if (response.isEmpty) {
        return [];
      }
      return response;
    });
  }

  // select
  @override
  Future<List<Map<String, dynamic>>> fetch() async {
    final response = await supabase.client.from(tableName).select();
    if (response.isEmpty) {
      // Supabaseのデータがないときは、空のリストを返す
      return [];
    }
    return response;
  }

  // delete
  @override
  Future<void> delete(Map<String, dynamic> data) async {
    await supabase.client.from(tableName).delete().eq(primaryKey, data[primaryKey]);
  }
}