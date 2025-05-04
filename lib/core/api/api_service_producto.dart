import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceProducto {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // GET
  Future<List<Map<String, dynamic>>> getProductos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Error al obtener productos: ${response.statusCode}");
    }
  }

  // POST
  Future<Map<String, dynamic>> createProducto(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al agregar producto: ${response.statusCode}");
    }
  }

  // PUT
  Future<Map<String, dynamic>> updateProducto(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al actualizar producto: ${response.statusCode}");
    }
  }

  // DELETE
  Future<void> deleteProducto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception("Error al eliminar producto: ${response.statusCode}");
    }
  }
}
