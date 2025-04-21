import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cajero_app/service/service.dart';

// Widget para manejar datos dinámicos
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Estado de la pantalla de inicio
class _HomeScreenState extends State<HomeScreen> {
  // Variable para manejar el índice seleccionado en la barra de navegación inferior
  int _selectedIndex = 0;
  // Variable para manejar el nombre del usuario
  final String nombreUsuario = "Usuario";
  // Variables para manejar el saldo y estado de carga
  double? saldo;
  bool isLoading = true;
  String? errorMessage;
  int? userId;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Cargamos el saldo cuando se inicia la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = ModalRoute.of(context)!.settings.arguments as int?;
      _cargarSaldo();
    });
  }

  // Método para cargar el saldo del usuario
  Future<void> _cargarSaldo() async {
    if (userId == null) {
      setState(() {
        errorMessage = "No se encontró información del usuario";
        isLoading = false;
      });
      return;
    }

    try {
      final saldoObtenido = await apiService.obtenerSaldo(userId!);
      setState(() {
        saldo = saldoObtenido;
        isLoading = false;
        errorMessage = saldoObtenido == null ? "Error al obtener saldo" : null;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error de conexión: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  // Método para formatear el saldo en formato de moneda
  String formatearSaldo(double? valor) {
    if (valor == null) return "\$0.00";
    return "\$${valor.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Definimos la barra de navegación superior
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenido",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nombreUsuario,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFFE53935)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Cerrar sesión"),
                    content: const Text("¿Estás seguro que deseas salir?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navegar al login (ruta principal)
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(color: Color(0xFF0958B8)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cuenta",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0958B8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Valor disponible",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    isLoading
                        ? const CircularProgressIndicator(
                          color: Color(0xFF0958B8),
                        )
                        : errorMessage != null
                        ? Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                        : Text(
                          formatearSaldo(saldo),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // Si hay error o está cargando, intentar cargar de nuevo
                            if (errorMessage != null || isLoading) {
                              setState(() {
                                isLoading = true;
                                errorMessage = null;
                              });
                              _cargarSaldo();
                            }
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: Color(0xFF0958B8),
                          ),
                          label: Text(
                            errorMessage != null || isLoading
                                ? "Actualizar"
                                : "Ver detalles",
                            style: const TextStyle(color: Color(0xFF0958B8)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0958B8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0958B8),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFC9C9C9),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index != _selectedIndex) {
            setState(() {
              _selectedIndex = index;
            });

            // Navegación actualizada con el ID del usuario
            if (index == 0) {
              // Ya estamos en Home, no necesitamos navegar
            } else if (index == 1) {
              // Navegar a la pantalla de transferencias/ingresos
              Navigator.pushReplacementNamed(
                context,
                '/transfers',
                arguments: userId,
              );
            } else if (index == 2) {
              // Navegar a la pantalla de retiros
              Navigator.pushReplacementNamed(
                context,
                '/withdrawals',
                arguments: userId,
              );
            }
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transferencia',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Retiros'),
        ],
      ),
    );
  }
}
