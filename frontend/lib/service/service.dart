import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.13:8080';

  Future<Map<String, dynamic>> login(String correo, String contrasena) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
    );

    final data = jsonDecode(response.body);
    return {'success': data['success'], 'id': data['id']};
  }

  Future<double?> obtenerSaldo(int idUsuario) async {
    final url = Uri.parse('$baseUrl/saldo/$idUsuario');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.tryParse(data['saldo'].toString());
    } else {
      return null;
    }
  }

  Future<String> ingresarSaldo(int idUsuario, double monto) async {
    final url = Uri.parse('$baseUrl/ingresar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario, 'monto': monto}),
    );
    final data = jsonDecode(response.body);
    return data['message'] ??
        (data['success'] ? 'Ingreso exitoso' : 'Error al ingresar');
  }

  Future<String> retirarSaldo(int idUsuario, double monto) async {
    final url = Uri.parse('$baseUrl/retirar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_usuario': idUsuario,
        'monto': monto,
      }), // Usa id_usuario
    );
    final data = jsonDecode(response.body);
    return data['message'] ?? 'Error al retirar';
  }
}
