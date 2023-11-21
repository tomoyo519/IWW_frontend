

/// Local DataSource로는 sqlite 사용

// @DriftDatabase()
// class LocalDatabase extends _$AppDatabase {}

class LocalDataSource {
  LocalDataSource._internal();
  static final _instance = LocalDataSource._internal();
  static LocalDataSource get instanct => _instance;

  // Future
// static Database? _db;
// static Database? get db => _db;

// init() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   openDatabase(join(await getDatabasesPath(), 'local.db'),
//       onCreate: (db, version) {
//     // 여기에 SQL 쿼리문 쭉 작성
//     return db.execute('''
//         CREATE TABLE user(
//           userId INTEGER PRIMARY KEY,
//           userName TEXT,
//           userTel TEXT,
//           userKakaoId INTEGER,
//           userHp INTEGER
//         )
//         ''');
//   }, version: 1);
// }
}
