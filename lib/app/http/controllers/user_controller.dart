import 'package:vania/vania.dart';
import 'package:tugas_restapi_vania_david/app/models/user.dart';

class UserController extends Controller {
  Future<Map<String, dynamic>> registerUser(
      String username, String email, String hashedPassword) async {
    try {
      // Cek apakah email sudah terdaftar
      final existingUser = await User().query().where('email', email).first();
      if (existingUser != null) {
        return {
          'status': 'error',
          'message': 'Email sudah terdaftar',
        };
      }

      // Create user
      final user = await User().query().create({
        'username': username,
        'email': email,
        'password': hashedPassword,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (user == null) {
        return {
          'status': 'error',
          'message': 'Gagal membuat user',
        };
      }

      return {
        'status': 'success',
        'message': 'Registrasi berhasil',
        'data': {
          'id': user['id'],
          'username': user['username'],
          'email': user['email'],
          'created_at': user['created_at'],
        }
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan saat registrasi',
        'error': e.toString(),
      };
    }
  }
}
