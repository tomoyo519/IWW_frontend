import 'package:drift/drift.dart';

class User extends Table {
  @override
  String get tableName => 'User';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text()();
  TextColumn get userTel => text()();
  IntColumn get userHp => integer()();
}
