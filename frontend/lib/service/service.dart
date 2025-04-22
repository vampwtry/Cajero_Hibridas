// Importaciones necesarias para el funcionamiento del código
import 'dart:convert'; // Importa utilidades para codificar y decodificar JSON
import 'package:http/http.dart'
    as http; // Importa la librería http para realizar solicitudes HTTP

// Clase que define los servicios para interactuar con el backend
class ApiService {
  // URL base del backend
  static const String baseUrl = 'http://192.168.1.13:8080';

  // Método para autenticar a un usuario mediante correo y contraseña
  Future<Map<String, dynamic>> login(String correo, String contrasena) async {
    // Construimos la URL para el endpoint de login
    final url = Uri.parse('$baseUrl/login');

    // Realizamos una solicitud POST al backend con los datos del usuario
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      }, // Cabecera para indicar que el cuerpo es JSON
      body: jsonEncode({
        'correo': correo,
        'contrasena': contrasena,
      }), // Codificamos los datos como JSON
    );

    // Decodificamos la respuesta del backend (esperamos un JSON)
    final data = jsonDecode(response.body);

    // Devolvemos un mapa con el estado de éxito y el ID del usuario
    return {'success': data['success'], 'id': data['id']};
  }

  // Método para obtener el saldo de un usuario específico
  Future<double?> obtenerSaldo(int idUsuario) async {
    // Construimos la URL para el endpoint de saldo, incluyendo el ID del usuario
    final url = Uri.parse('$baseUrl/saldo/$idUsuario');

    // Realizamos una solicitud GET al backend
    final response = await http.get(url);

    // Verificamos si la solicitud fue exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodificamos la respuesta del backend (esperamos un JSON)
      final data = jsonDecode(response.body);
      // Intentamos convertir el saldo a double y lo devolvemos
      return double.tryParse(data['saldo'].toString());
    } else {
      // Si la solicitud falla, devolvemos null
      return null;
    }
  }

  // Método para realizar un depósito (ingresar saldo) a la cuenta de un usuario
  Future<String> ingresarSaldo(int idUsuario, double monto) async {
    // Construimos la URL para el endpoint de ingreso de saldo
    final url = Uri.parse('$baseUrl/ingresar');

    // Realizamos una solicitud POST al backend con los datos del depósito
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      }, // Cabecera para indicar que el cuerpo es JSON
      body: jsonEncode({
        'id_usuario': idUsuario,
        'monto': monto,
      }), // Codificamos los datos como JSON
    );

    // Decodificamos la respuesta del backend (esperamos un JSON)
    final data = jsonDecode(response.body);

    // Devolvemos el mensaje del backend o un mensaje por defecto según el estado de éxito
    return data['message'] ??
        (data['success'] ? 'Ingreso exitoso' : 'Error al ingresar');
  }

  // Método para realizar un retiro de saldo de la cuenta de un usuario
  Future<String> retirarSaldo(int idUsuario, double monto) async {
    // Construimos la URL para el endpoint de retiro de saldo
    final url = Uri.parse('$baseUrl/retirar');

    // Realizamos una solicitud POST al backend con los datos del retiro
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      }, // Cabecera para indicar que el cuerpo es JSON
      body: jsonEncode({
        'id_usuario': idUsuario,
        'monto': monto,
      }), // Codificamos los datos como JSON (usamos id_usuario para el backend)
    );

    // Decodificamos la respuesta del backend (esperamos un JSON)
    final data = jsonDecode(response.body);

    // Devolvemos el mensaje del backend o un mensaje por defecto si no hay mensaje
    return data['message'] ?? 'Error al retirar';
  }
}
