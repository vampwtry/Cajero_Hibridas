import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

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
  // definimos la interfaz de la pantalla de inicio utilizando un Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Definimos la barra de navegación superior
      // con un AppBar que tiene un título y un botón de cerrar sesión
      appBar: AppBar(
        // Aumentamos el tamaño de la barra de navegación superior
        toolbarHeight: 100,
        title: Column(
          // Alineamos el texto a la izquierda
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
                fontSize: 24, // Tamaño más grande para el nombre del usuario
              ),
            ),
          ],
        ),
        // Lista de acciones en la barra de navegación superior
        actions: [
          // Botón de cerrar sesión
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFFE53935)),
            // Cuando se presiona el botón, se muestra un modal de confirmación
            onPressed: () {
              // Mostrar modal de confirmación
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Retornamos un AlertDialog para confirmar la acción
                  return AlertDialog(
                    title: const Text("Cerrar sesión"),
                    content: const Text("¿Estás seguro que deseas salir?"),
                    actions: [
                      // Botón de cancelar
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar el diálogo
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      // Botón de confirmar
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar el diálogo
                          Navigator.pushReplacementNamed(
                            context,
                            '/',
                          ); // Volver al login
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
      // Aplicamos un efecto de desvanecimiento a la pantalla principal
      body: FadeIn(
        duration: const Duration(milliseconds: 800),
        // Margen interna para todos los lados
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Centramos el contenido de la pantalla
          child: Center(
            // Aplicamos un efecto de desvanecimiento a la tarjeta
            child: Card(
              // Agregamos una sombra a la tarjeta
              elevation: 5,
              // Se agrega bordes redondeado a la tarjeta
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // Contenedor dentro de la tarjeta con el ancho completo
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
                    const Text(
                      "\$1,500,000.00",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Alineamos el botón a la derecha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Boton con icono y texto para ver detalles
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.visibility,
                            color: Color(0xFF0958B8),
                          ),
                          label: const Text(
                            "Ver detalles",
                            style: TextStyle(color: Color(0xFF0958B8)),
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
      // Barra de navegación inferior con las tres opciones
      bottomNavigationBar: BottomNavigationBar(
        //Fondo de la barra de navegación inferior
        backgroundColor: Color(0xFF0958B8),
        // Indicamos el elemento seleccionado
        currentIndex: _selectedIndex,
        // Iconos y etiquetas de los elementos de la barra de navegación inferior
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFC9C9C9),
        // Mantenemos los elementos fijos en la barra de navegación inferior
        type: BottomNavigationBarType.fixed,
        // Manejamos los clicks con el método onTap
        onTap: (index) {
          // Verificamos si el índice seleccionado es diferente al índice actual
          // para evitar cambios innecesarios
          if (index != _selectedIndex) {
            setState(() {
              _selectedIndex = index;
            });

            // Navegación actualizada
            if (index == 0) {
            } else if (index == 1) {
              // Navegar a la pantalla de transferencias
              Navigator.pushReplacementNamed(context, '/transfers');
            } else if (index == 2) {
              // Navegar a la pantalla de retiros
              Navigator.pushReplacementNamed(context, '/withdrawals');
            }
          }
        },
        // Definimos los elementos de la barra de navegación inferior
        // cada uno con un icono y una etiqueta
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
