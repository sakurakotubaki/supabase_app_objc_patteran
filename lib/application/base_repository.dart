import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BaseRepository {
  // このゲッターは、クラス内で、テーブル名とプライマリーキーを取得するために使用されます。
  String get tableName;

  String get primaryKey;
}

class BaseRepositoryImpl implements BaseRepository {
  // Supabaseインスタンスを取得
  final Supabase supabase = Supabase.instance;

  /// [UnimplementedError]とは、未実装のメソッドが呼ばれた場合に発生するエラーです。
  /// このクラスはベースクラスなので、ゲッターには値はありません。
  @override
  String get tableName => throw UnimplementedError();

  @override
  String get primaryKey => throw UnimplementedError();
}