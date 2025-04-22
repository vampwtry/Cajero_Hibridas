// Importaciones necesarias para el funcionamiento del código
import 'package:flutter/material.dart'; // Importa el framework Flutter para construir la interfaz de usuario
import 'package:flutter/services.dart'; // Importa utilidades para manejar formatos de entrada (como entrada numérica)
import 'package:animate_do/animate_do.dart'; // Importa la librería animate_do para agregar animaciones a los widgets
import 'package:cajero_app/service/service.dart'; // Importa el servicio ApiService para manejar solicitudes al backend

// Definimos un StatefulWidget para manejar un estado dinámico en la pantalla de depósitos
class TransferScreen extends StatefulWidget {
  // Constructor constante con una clave opcional para identificar el widget
  const TransferScreen({Key? key}) : super(key: key);

  // Creamos el estado asociado al widget
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

// Clase que contiene el estado y la lógica de TransferScreen
class _TransferScreenState extends State<TransferScreen> {
  // Variable para manejar el índice seleccionado en la barra de navegación inferior (1 para "Transferencia")
  int _selectedIndex = 1;

  // Controlador para capturar el texto ingresado en el campo de monto
  final TextEditingController _amountController = TextEditingController();

  // Instancia de ApiService para realizar solicitudes al backend
  final ApiService _apiService = ApiService();

  // Variable para controlar el estado de carga durante el procesamiento del depósito
  bool _isLoading = false;

  // Variable para almacenar el ID del usuario, obtenido de los argumentos de la ruta
  int? userId;

  // Lista de valores predefinidos para los botones de depósito rápido
  final List<String> _predefinedAmounts = [
    '20.000',
    '50.000',
    '100.000',
    '200.000',
    '300.000',
    '400.000',
  ];

  // Método que se ejecuta cuando se inicializa el estado del widget
  @override
  void initState() {
    super.initState();
    // Ejecutamos la obtención del userId después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Obtenemos el userId de los argumentos de la ruta
      userId = ModalRoute.of(context)!.settings.arguments as int?;
      print('User ID recibido: $userId'); // Log para depuración
      // Validamos que el userId no sea null
      if (userId == null) {
        // Si no se encuentra el userId, mostramos un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se encontró el ID del usuario'),
          ),
        );
      }
    });
  }

  // Método para procesar el depósito
  Future<void> _processDeposit() async {
    // Validamos que el campo de monto no esté vacío
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese un valor a depositar')),
      );
      return; // Salimos del método
    }

    // Validamos que el userId no sea null
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se identificó al usuario')),
      );
      return; // Salimos del método
    }

    // Convertimos el texto ingresado a un valor numérico (double)
    double amount;
    try {
      // Eliminamos los puntos para manejar los valores predefinidos (como "20.000")
      String amountText = _amountController.text.replaceAll('.', '');
      amount = double.parse(amountText);
      print('Monto a depositar: $amount'); // Log para depuración
    } catch (e) {
      // Si falla la conversión, mostramos un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese un valor numérico válido'),
        ),
      );
      return; // Salimos del método
    }

    // Validamos que el monto sea mayor a cero
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El monto debe ser mayor a cero')),
      );
      return; // Salimos del método
    }

    // Cambiamos el estado para indicar que se está procesando el depósito
    setState(() {
      _isLoading = true; // Mostramos un indicador de carga
    });

    try {
      // Llamamos al método ingresarSaldo de ApiService para realizar el depósito
      String result = await _apiService.ingresarSaldo(userId!, amount);

      // Verificamos si la operación fue exitosa según el mensaje devuelto
      if (result.contains('exitoso') || !result.contains('Error')) {
        // Mostramos un diálogo para confirmar que el depósito fue exitoso
        showDialog(
          context: context,
          barrierDismissible: false, // El usuario debe usar un botón para cerrar
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              title: const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60), // Ícono de éxito
                  SizedBox(height: 10),
                  Text(
                    "¡Depósito Exitoso!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0958B8), // Color azul
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min, // Tamaño mínimo
                children: [
                  Text(
                    "Has depositado \$${amount.toStringAsFixed(2)} correctamente.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "¿Deseas realizar otra operación?",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                // Botón para realizar otro depósito
                TextButton(
                  onPressed: () {
                    _amountController.clear(); // Limpiamos el campo de texto
                    Navigator.pop(context); // Cerramos el diálogo
                  },
                  child: const Text(
                    "Realizar otro depósito",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Botón para volver al inicio
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerramos el diálogo
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                      arguments: userId, // Pasamos el userId
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0958B8), // Fondo azul
                    foregroundColor: Colors.white, // Texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Bordes redondeados
                    ),
                  ),
                  child: const Text("Volver al Inicio"),
                ),
              ],
            );
          },
        );
      } else {
        // Si la operación falla, mostramos el mensaje de error del backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Manejamos errores de conexión o del servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en la conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Finalizamos el estado de carga
      setState(() {
        _isLoading = false; // Ocultamos el indicador de carga
      });
    }
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de navegación superior (AppBar)
      appBar: AppBar(
        toolbarHeight: 100, // Altura personalizada
        title: const Text(
          "Depósito",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: [
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFFE53935)), // Ícono rojo de salida
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
                          Navigator.pushReplacementNamed(
                            context,
                            '/', // Navegamos a la pantalla de login
                          );
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
        duration: const Duration(milliseconds: 600), // Animación de entrada
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Margen alrededor del contenido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupa todo el ancho
            children: [
              // Tarjeta principal para el formulario de depósito
              Card(
                elevation: 5, // Sombra de la tarjeta
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Margen interno
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alineamos a la izquierda
                    children: [
                      const Text(
                        "Depósito a cuenta",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0958B8), // Color azul
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Ingrese el valor a depositar:",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 15),
                      // Campo de texto para ingresar el monto
                      TextFormField(
                        controller: _amountController, // Vinculamos el controlador
                        decoration: InputDecoration(
                          labelText: "Valor", // Etiqueta del campo
                          prefixText: "\$ ", // Prefijo de moneda
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF0958B8), // Borde azul al estar enfocado
                              width: 2,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number, // Teclado numérico
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Botón para confirmar el depósito
                      SizedBox(
                        width: double.infinity, // Ocupa todo el ancho
                        height: 50, // Altura fija
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _processDeposit, // Desactivamos si está cargando
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0958B8), // Fondo azul
                            foregroundColor: Colors.white, // Texto blanco
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Bordes redondeados
                            ),
                            elevation: 2, // Sombra ligera
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                ) // Indicador de carga
                              : const Text(
                                  "Confirmar Depósito",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25), // Espacio entre secciones

              // Título para la sección de valores rápidos
              const Text(
                "Valores rápidos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 15), // Espacio

              // Sección de botones con valores predefinidos
              Expanded(
                child: FadeInUp(
                  duration: const Duration(milliseconds: 800), // Animación de entrada
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columnas
                      crossAxisSpacing: 10, // Espacio horizontal entre botones
                      mainAxisSpacing: 10, // Espacio vertical entre botones
                      childAspectRatio: 2.5, // Proporción de los botones
                    ),
                    itemCount: _predefinedAmounts.length, // Número de botones
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                        onPressed: () {
                          setState(() {
                            // Establecemos el valor predefinido en el campo de texto
                            _amountController.text =
                                _predefinedAmounts[index].replaceAll('.', '');
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0958B8)), // Borde azul
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Bordes redondeados
                          ),
                        ),
                        child: Text(
                          "\$${_predefinedAmounts[index]}", // Mostramos el valor con prefijo $
                          style: const TextStyle(
                            color: Color(0xFF0958B8), // Color azul
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0958B8), // Fondo azul
        currentIndex: _selectedIndex, // Índice seleccionado
        selectedItemColor: const Color(0xFFFFFFFF), // Color blanco para el ítem seleccionado
        unselectedItemColor: const Color(0xFFC9C9C9), // Color gris para ítems no seleccionados
        onTap: (index) {
          // Cambiamos de pantalla solo si el índice es diferente al actual
          if (index != _selectedIndex) {
            if (index == 0) {
              // Navegamos a la pantalla principal
              Navigator.pushReplacementNamed(
                context,
                '/home',
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
            // No hacemos nada si el índice es 1 porque ya estamos en esta pantalla
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