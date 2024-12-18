import 'package:mysql1/mysql1.dart';

class Database {
  static final ConnectionSettings _settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'tugasdavid',
    password: 'tugasrestapi',
    db: 'tugas_restapi_vania_david',
  );

  static Future<MySqlConnection> getConnection() async {
    try {
      return await MySqlConnection.connect(_settings);
    } catch (e) {
      throw Exception('Database connection failed: $e');
    }
  }

  static query(String s) {}
}
