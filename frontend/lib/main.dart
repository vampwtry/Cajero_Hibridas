import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'retirar_screen.dart';
import 'ingresar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cajero Automático',
      theme: ThemeData(
        primaryColor: const Color(0xFF0958B8),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0958B8),
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/withdrawals': (context) => const WithdrawalsScreen(),
        '/transfers': (context) => const TransferScreen(),
      },
    );
  }
}