// Importaciones necesarias para el funcionamiento del código
import 'package:flutter/material.dart'; // Importa el framework Flutter para construir la interfaz de usuario
import 'package:animate_do/animate_do.dart'; // Importa la librería animate_do para agregar animaciones a los widgets
import 'package:cajero_app/service/service.dart'; // Importa el servicio ApiService para manejar solicitudes al backend

// Definimos un StatefulWidget para manejar un estado dinámico en la pantalla principal
class HomeScreen extends StatefulWidget {
  // Constructor constante con una clave opcional para identificar el widget
  const HomeScreen({Key? key}) : super(key: key);

  // Creamos el estado asociado al widget
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Clase que contiene el estado y la lógica de HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  // Variable para manejar el índice seleccionado en la barra de navegación inferior
  int _selectedIndex = 0;

  // Variable para almacenar el nombre del usuario (por ahora estático, podría ser dinámico)
  final String nombreUsuario = "Usuario";

  // Variables para manejar el saldo y el estado de la pantalla
  double? saldo; // Almacena el saldo del usuario, puede ser null si no se ha cargado
  bool isLoading = true; // Indica si se está cargando el saldo
  String? errorMessage; // Almacena un mensaje de error si ocurre un problema
  int? userId; // Almacena el ID del usuario, obtenido de los argumentos de la ruta

  // Instancia de ApiService para realizar solicitudes al backend
  final ApiService apiService = ApiService();

  // Método que se ejecuta cuando se inicializa el estado del widget
  @override
  void initState() {
    super.initState();
    // Ejecutamos la carga del saldo después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Obtenemos el userId de los argumentos de la ruta
      userId = ModalRoute.of(context)!.settings.arguments as int?;
      // Llamamos al método para cargar el saldo
      _cargarSaldo();
    });
  }

  // Método para cargar el saldo del usuario desde el backend
  Future<void> _cargarSaldo() async {
    // Validamos que el userId no sea null
    if (userId == null) {
      setState(() {
        errorMessage = "No se encontró información del usuario";
        isLoading = false; // Terminamos la carga
      });
      return; // Salimos del método
    }

    try {
      // Llamamos al método obtenerSaldo de ApiService para obtener el saldo
      final saldoObtenido = await apiService.obtenerSaldo(userId!);
      setState(() {
        saldo = saldoObtenido; // Actualizamos el saldo
        isLoading = false; // Terminamos la carga
        // Si no se obtuvo el saldo, mostramos un mensaje de error
        errorMessage = saldoObtenido == null ? "Error al obtener saldo" : null;
      });
    } catch (e) {
      // Manejar errores de conexión o del servidor
      setState(() {
        errorMessage = "Error de conexión: ${e.toString()}";
        isLoading = false; // Terminamos la carga
      });
    }
  }

  // Método para formatear el saldo en formato de moneda con separadores de miles
  String formatearSaldo(double? valor) {
    // Si el valor es null, devolvemos "$0.00"
    if (valor == null) return "\$0.00";
    // Formateamos el número con 2 decimales y añadimos separadores de miles
    return "\$${valor.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de navegación superior (AppBar)
      appBar: AppBar(
        toolbarHeight: 100, // Altura personalizada de la barra
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alineamos el texto a la izquierda
          children: [
            const Text(
              "Bienvenido",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4), // Espacio entre los textos
            Text(
              nombreUsuario, // Mostramos el nombre del usuario
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color(0xFFE53935),
            ), // Ícono rojo de salida
            onPressed: () {
              // Mostramos un diálogo de confirmación para cerrar sesión
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Cerrar sesión"),
                    content: const Text("¿Estás seguro que deseas salir?"),
                    actions: [
                      // Botón para cancelar
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerramos el diálogo
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      // Botón para confirmar
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerramos el diálogo
                          // Navegamos a la pantalla de login (ruta raíz)
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

      // Cuerpo principal de la pantalla
      body: FadeIn(
        duration: const Duration(milliseconds: 800), // Animación de entrada
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Margen alrededor del contenido
          child: Center(
            child: Card(
              elevation: 5, // Sombra de la tarjeta
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              child: Container(
                width: double.infinity, // Ocupa todo el ancho disponible
                padding: const EdgeInsets.all(
                  20,
                ), // Margen interno de la tarjeta
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Tamaño mínimo para el contenido
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineamos a la izquierda
                  children: [
                    // Título "Cuenta"
                    const Text(
                      "Cuenta",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0958B8), // Color azul
                      ),
                    ),
                    const SizedBox(height: 10), // Espacio
                    // Subtítulo "Valor disponible"
                    const Text(
                      "Valor disponible",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 5), // Espacio
                    // Mostramos el saldo o un mensaje según el estado
                    isLoading
                        ? const CircularProgressIndicator(
                          color: Color(0xFF0958B8), // Indicador de carga azul
                        )
                        : errorMessage != null
                        ? Text(
                          errorMessage!, // Mostramos el mensaje de error
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                        : Text(
                          formatearSaldo(
                            saldo,
                          ), // Mostramos el saldo formateado
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    const SizedBox(height: 20), // Espacio adicional
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0958B8), // Fondo azul
        currentIndex: _selectedIndex, // Índice seleccionado
        selectedItemColor: const Color(
          0xFFFFFFFF,
        ), // Color blanco para el ítem seleccionado
        unselectedItemColor: const Color(
          0xFFC9C9C9,
        ), // Color gris para ítems no seleccionados
        type:
            BottomNavigationBarType
                .fixed, // Tipo fijo para mantener todos los ítems visibles
        onTap: (index) {
          // Cambiamos el índice solo si es diferente al actual
          if (index != _selectedIndex) {
            setState(() {
              _selectedIndex = index; // Actualizamos el índice seleccionado
            });

            // Navegamos según el índice seleccionado, pasando el userId
            if (index == 0) {
              // Ya estamos en Home, no necesitamos navegar
            } else if (index == 1) {
              // Navegamos a la pantalla de transferencias/ingresos
              Navigator.pushReplacementNamed(
                context,
                '/transfers',
                arguments: userId, // Pasamos el userId
              );
            } else if (index == 2) {
              // Navegamos a la pantalla de retiros
              Navigator.pushReplacementNamed(
                context,
                '/withdrawals',
                arguments: userId, // Pasamos el userId
              );
            }
          }
        },
        items: const [
          // Ítems de la barra de navegación
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
