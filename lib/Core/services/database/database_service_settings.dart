class DatabaseServiceSettings {
  static const int version = 1;
  static const List<SqlTable> tables = [
    SqlTable(
      name: "notifications",
      sql: '''
      CREATE TABLE "notifications_table" (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      subtitle TEXT NULL,
      html TEXT NULL,
      image_url TEXT NULL,
      date datetime NOT NULL,
      seen INTEGER NOT NULL DEFAULT 0
      ) 
      ''',
    ),
  ];
}

class SqlTable {
  final String name;
  final String sql;

  const SqlTable({required this.name, required this.sql});
}
