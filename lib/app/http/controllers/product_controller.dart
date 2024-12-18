import 'package:tugas_restapi_vania_david/services/database.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
  // Menambahkan produk baru (POST)
  Future<Response> create(Request request) async {
    try {
      final Map<String, dynamic> requestData = request.body;

      if (requestData['name'] == null || requestData['price'] == null) {
        return Response.json({
          "message": "Nama dan harga produk wajib diisi",
        }, 400);
      }

      // Insert product into MySQL database
      final conn = await Database.getConnection();
      var result = await conn.query(
        'INSERT INTO products (name, price, description) VALUES (?, ?, ?)',
        [
          requestData['name'],
          requestData['price'],
          requestData['description'] ?? ""
        ],
      );

      // Ambil ID yang baru saja diinsert
      final insertedId = result.insertId;

      await conn.close();

      return Response.json({
        "message": "Produk berhasil ditambahkan",
        "data": {
          "id": insertedId,
          "name": requestData['name'],
          "price": requestData['price'],
          "description": requestData['description'] ?? "",
        },
      }, 201);
    } catch (e) {
      return Response.json({
        "message": "Error terjadi pada server, silakan coba lagi nanti",
        "error": e.toString(),
      }, 500);
    }
  }


  // Mendapatkan daftar produk (GET)
  Future<Response> index() async {
    try {
      final conn = await Database.getConnection();
      var results =
          await conn.query('SELECT id, name, price, description FROM products');

      List<Map<String, dynamic>> productList = results.map((row) {
        return {
          "id": row['id'],
          "name": row['name'],
          "price": row['price'],
          "description": row['description'],
        };
      }).toList();

      await conn.close();

      return Response.json({
        "message": "Daftar produk berhasil diambil",
        "data": productList,
      });
    } catch (e) {
      return Response.json({
        "message": "Error terjadi pada server, silakan coba lagi nanti",
        "error": e.toString(),
      }, 500);
    }
  }


  // Memperbarui data produk (PUT)
  // Memperbarui data produk (PUT)
  // Memperbarui data produk (PUT)
  // Memperbarui data produk (PUT)
  Future<Response> update(Request request, String id) async {
    try {
      final Map<String, dynamic> requestData = request.body;

      // Check if required fields are provided
      if (requestData['name'] == null || requestData['price'] == null) {
        return Response.json({
          "message": "Nama dan harga produk wajib diisi",
        }, 400);
      }

      final parsedId = int.tryParse(id);
      if (parsedId == null || parsedId <= 0) {
        return Response.json({
          "message": "ID produk tidak valid",
        }, 400);
      }

      final conn = await Database.getConnection();

      // Check if the product exists in the database
      var existingProduct = await conn.query(
        'SELECT id FROM products WHERE id = ?',
        [parsedId],
      );

      if (existingProduct.isEmpty) {
        await conn.close();
        return Response.json({
          "message": "Produk dengan ID $id tidak ditemukan",
        }, 404);
      }

      // Update product in the database
      var result = await conn.query(
        'UPDATE products SET name = ?, price = ?, description = ? WHERE id = ?',
        [
          requestData['name'],
          requestData['price'],
          requestData['description'] ?? "",
          parsedId
        ],
      );

      // Fetch the updated product from the database
      var updatedProduct = await conn.query(
        'SELECT id, name, price, description FROM products WHERE id = ?',
        [parsedId],
      );

      await conn.close();

      if (updatedProduct.isEmpty) {
        return Response.json({
          "message": "Produk dengan ID $id tidak dapat diperbarui",
        }, 404);
      }

      var product = updatedProduct.first;

      return Response.json({
        "message": "Produk berhasil diperbarui",
        "data": {
          "id": product['id'],
          "name": product['name'],
          "price": product['price'],
          "description": product['description'],
        },
      });
    } catch (e) {
      return Response.json({
        "message": "Error terjadi pada server, silakan coba lagi nanti",
        "error": e.toString(),
      }, 500);
    }
  }

// Menghapus produk berdasarkan ID (DELETE)
  Future<Response> delete(Request request, String id) async {
    try {
      final parsedId = int.tryParse(id);
      if (parsedId == null || parsedId <= 0) {
        return Response.json({
          "message": "ID produk tidak valid",
        }, 400);
      }

      final conn = await Database.getConnection();
      var result = await conn.query(
        'DELETE FROM products WHERE id = ?',
        [parsedId],
      );

      await conn.close();

      if (result.affectedRows == 0) {
        return Response.json({
          "message": "Produk dengan ID $id tidak ditemukan",
        }, 404);
      }

      return Response.json({
        "message": "Produk dengan ID $id berhasil dihapus",
      });
    } catch (e) {
      return Response.json({
        "message": "Error terjadi pada server, silakan coba lagi nanti",
        "error": e.toString(),
      }, 500);
    }
  }
}
