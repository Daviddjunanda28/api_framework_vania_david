import 'dart:convert';
import 'package:tugas_restapi_vania_david/app/http/controllers/product_controller.dart';
import 'package:tugas_restapi_vania_david/app/http/controllers/user_controller.dart';
import 'package:vania/vania.dart';
import 'package:argon2/argon2.dart'; // For hashing passwords

class ApiRoute implements Route {
  @override
  void register() {
    // Endpoint untuk register user
    Router.post("/register", (Request request) async {
      try {
        // Mendapatkan body request
        final bodyRaw = await request.body;

        // Validasi jika body kosong
        if (bodyRaw == null || bodyRaw.isEmpty) {
          return Response.json(
              {"status": "error", "message": "Body request tidak boleh kosong"},
              400);
        }

        // Parse JSON
        final Map<String, dynamic> body = jsonDecode(bodyRaw as String);

        final username = body['username'];
        final email = body['email'];
        final password = body['password'];

        // Validasi input dengan response yang lebih informatif
        if (username == null || username.isEmpty) {
          return Response.json({
            "status": "error",
            "message": "Username tidak boleh kosong",
            "received_data": {"username": username}
          }, 400);
        }
        if (email == null || email.isEmpty) {
          return Response.json({
            "status": "error",
            "message": "Email tidak boleh kosong",
            "received_data": {"email": email}
          }, 400);
        }
        if (password == null || password.isEmpty) {
          return Response.json({
            "status": "error",
            "message": "Password tidak boleh kosong",
            "received_data": {"password": "hidden"}
          }, 400);
        }

        // Hash password menggunakan Argon2
        final hashedPassword = await Argon2().hashPasswordString(password);

        // Simpan user ke database dan dapatkan hasil
        final result = await UserController()
            .registerUser(username, email, hashedPassword);

        // Menambahkan informasi request yang diterima ke dalam response
        final response = {
          ...result,
          "received_request": {
            "username": username,
            "email": email,
            "password": "hidden" // Untuk keamanan
          }
        };

        return Response.json(
            response, result['status'] == 'success' ? 201 : 400);
      } catch (e) {
        return Response.json({
          "status": "error",
          "message": "Terjadi kesalahan pada server",
          "error": e.toString()
        }, 500);
      }
    });





    // Rute untuk menambahkan produk (POST)
    Router.post("/products", ProductController().create);

    // Rute untuk mendapatkan daftar produk (GET)
    Router.get("/products", ProductController().index);

    // Rute untuk mengupdate produk berdasarkan ID (PUT)
    Router.put("/products/:id", (Request request) async {
      final params = request.params();
      final id = params['id'];
      if (id == null || id.isEmpty) {
        return Response.json({
          "message": "ID tidak valid atau tidak ditemukan",
        }, 400);
      }
      return await ProductController().update(request, id);
    });



    // Rute untuk menghapus produk berdasarkan ID (DELETE)
    Router.delete("/products/:id", (Request request) async {
      final params = request.params();
      final id = params['id'];
      if (id == null || id.isEmpty) {
        return Response.json({
          "message": "ID tidak valid atau tidak ditemukan",
        }, 400);
      }
      return await ProductController().delete(request, id);
    });

  }
}

Argon2() {
}
