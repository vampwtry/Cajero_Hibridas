import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

// Configuración de la conexión a la base de datos
final dbSettings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: null,
  db: 'cajero_hibridas',
);

void main() async {
  final router = Router();

  // Ruta para login
  router.post('/login', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final correo = data['correo'];
    final contrasena = data['contrasena'];

    final conn = await MySqlConnection.connect(dbSettings);
    final result = await conn.query(
      'SELECT id_usuario FROM usuario WHERE correo = ? AND contrasena = ?',
      [correo, contrasena],
    );

    await conn.close();

    if (result.isNotEmpty) {
      final id = result.first[0];
      return Response.ok(jsonEncode({'success': true, 'id': id}));
    } else {
      return Response.ok(jsonEncode({'success': false}));
    }
  });

  // soldo
  router.get('/saldo/<id>', (Request request, String id) async {
    final conn = await MySqlConnection.connect(dbSettings);
    try {
      final result = await conn.query(
        'SELECT saldo FROM usuario WHERE id_usuario = ?',
        [int.parse(id)], // Convertir el id a entero
      );
      if (result.isNotEmpty) {
        final saldo = result.first[0];
        return Response.ok(jsonEncode({'saldo': saldo}));
      } else {
        return Response.notFound('Usuario no encontrado');
      }
    } catch (e) {
      return Response.internalServerError(
        body: 'Error en la consulta a la base de datos',
      );
    } finally {
      await conn.close();
    }
  });

  // ingresar plata
  router.post('/ingresar', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final id = data['id_usuario'];
    final monto = data['monto'];

    final conn = await MySqlConnection.connect(dbSettings);
    await conn.query(
      'UPDATE usuario SET saldo = saldo + ? WHERE id_usuario = ?',
      [monto, id],
    );
    await conn.close();

    return Response.ok(
      jsonEncode({'success': true, 'message': 'Ingreso exitoso'}),
    );
  });

  // retirar
  router.post('/retirar', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final id = data['id_usuario'];
    final monto = data['monto'];

    final conn = await MySqlConnection.connect(dbSettings);
    final result = await conn.query(
      'SELECT saldo FROM usuario WHERE id_usuario = ?',
      [id],
    );

    if (result.isNotEmpty) {
      final saldoActual = result.first[0];
      if (saldoActual >= monto) {
        await conn.query(
          'UPDATE usuario SET saldo = saldo - ? WHERE id_usuario = ?',
          [monto, id],
        );
        await conn.close();
        return Response.ok(
          jsonEncode({'success': true, 'message': 'Retiro exitoso'}),
        );
      } else {
        await conn.close();
        return Response.ok(
          jsonEncode({'success': false, 'message': 'Saldo insuficiente'}),
        );
      }
    } else {
      await conn.close();
      return Response.notFound(
        jsonEncode({'success': false, 'message': 'Usuario no encontrado'}),
      );
    }
  });
  // servidor corriendo
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Servidor corriendo en http://${server.address.host}:${server.port}');
}
