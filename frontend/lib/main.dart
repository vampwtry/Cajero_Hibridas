// Importaciones necesarias para el funcionamiento del código
import 'package:flutter/material.dart'; // Importa el framework Flutter para construir la interfaz de usuario
import 'login_screen.dart'; // Importa la pantalla de inicio de sesión (LoginScreen)
import 'home_screen.dart'; // Importa la pantalla principal (HomeScreen)
import 'retirar_screen.dart'; // Importa la pantalla de retiros (WithdrawalsScreen)
import 'ingresar_screen.dart'; // Importa la pantalla de depósitos (TransferScreen)

// Punto de entrada principal de la aplicación
void main() {
  // Inicia la ejecución de la aplicación Flutter
  runApp(const MyApp());
}

// Definimos un StatelessWidget para la configuración principal de la aplicación
class MyApp extends StatelessWidget {
  // Constructor constante con una clave opcional para identificar el widget
  const MyApp({Key? key}) : super(key: key);

  // Método para construir la estructura de la aplicación
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Desactiva la bandera de modo debug en la esquina superior derecha
      debugShowCheckedModeBanner: false,

      // Título de la aplicación
      title: 'Cajero Automático',

      // Define el tema visual de la aplicación
      theme: ThemeData(
        // Color primario de la aplicación (usado en AppBar y otros elementos)
        primaryColor: const Color(0xFF0958B8),

        // Color de fondo predeterminado para los Scaffold
        scaffoldBackgroundColor: Colors.white,

        // Configuración del tema para la AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0958B8), // Fondo azul para la AppBar
          elevation: 0, // Sin sombra en la AppBar
        ),
      ),

      // Ruta inicial de la aplicación (pantalla de login)
      initialRoute: '/',

      // Definimos las rutas de navegación de la aplicación
      routes: {
        // Ruta raíz: pantalla de inicio de sesión
        '/': (context) => const LoginScreen(),

        // Ruta para la pantalla principal
        '/home': (context) => const HomeScreen(),

        // Ruta para la pantalla de retiros
        '/withdrawals': (context) => const WithdrawalsScreen(),

        // Ruta para la pantalla de depósitos (transferencias)
        '/transfers': (context) => const TransferScreen(),
      },
    );
  }
}
