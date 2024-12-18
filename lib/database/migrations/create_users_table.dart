import 'package:tugas_restapi_vania_david/services/database.dart';
import 'package:vania/vania.dart';

class UserController {
  Future<Map<String, dynamic>> registerUser(
      String username, String email, String password) async {
    try {
      // Insert data ke database
      final result = await Database.query('users').insert({
        'name': username,
        'email': email,
        'password': password,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });

      if (result != null) {
        return {"status": "success", "message": "User berhasil didaftarkan"};
      } else {
        return {
          "status": "error",
          "message": "Gagal menyimpan user ke database"
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Error saat menyimpan ke database",
        "error": e.toString()
      };
    }
  }
}
