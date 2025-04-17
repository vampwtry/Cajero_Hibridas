import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

class WithdrawalsScreen extends StatefulWidget {
  const WithdrawalsScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalsScreen> createState() => _WithdrawalsScreenState();
}

class _WithdrawalsScreenState extends State<WithdrawalsScreen> {
  int _selectedIndex = 2; // Inicializado en 2 para el botón de retiros
  // Controlador para el campo de texto donde se ingresa el valor a retirar
  final TextEditingController _amountController = TextEditingController();

  // Valores predefinidos para los botones de retiro
  final List<String> _predefinedAmounts = [
    '20.000',
    '50.000',
    '100.000',
    '200.000',
    '300.000',
    '400.000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "Retiro",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFFE53935)),
            onPressed: () {
              // Mostrar modal de confirmación
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Cerrar sesión"),
                    content: const Text("¿Estás seguro que deseas salir?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar el diálogo
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
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
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta principal para el retiro
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Retiro de dinero",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0958B8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Ingrese el valor a retirar:",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 15),
                      // Campo para ingresar el valor
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: "Valor",
                          prefixText: "\$ ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF0958B8),
                              width: 2,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Botón de confirmar retiro
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_amountController.text.isNotEmpty) {
                              // En un caso real, aquí iría la lógica para procesar el retiro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Procesando retiro de \$${_amountController.text}',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Por favor ingrese un valor a retirar',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0958B8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            "Confirmar Retiro",
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

              const SizedBox(height: 25),

              // Título para la sección de valores predefinidos
              const Text(
                "Valores rápidos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 15),

              // Botones de valores predefinidos
              Expanded(
                child: FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  // Cuadrícula para los botones de valores predefinidos
                  child: GridView.builder(
                    // Configuración de la cuadrícula
                    gridDelegate:
                    // Clase SliverGridDelegateWithFixedCrossAxisCount
                    // Para crear una cuadrícula con un número fijo de columnas
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      // 3 columnas
                      crossAxisCount: 3,
                      // espaciado entre botones
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      // proporción de aspecto (alto/ancho) de los botones
                      childAspectRatio: 2.5,
                    ),
                    // Numero de elementos en la cuadrícula
                    itemCount: _predefinedAmounts.length,
                    // Generamos cada botón de la cuadrícula
                    itemBuilder: (context, index) {
                      // Botones de valores predefinidos
                      return OutlinedButton(
                        // Actualizamos el campo de texto con el monto predefinido
                        onPressed: () {
                          setState(() {
                            // Establecer el valor del botón en el campo de texto
                            _amountController
                                .text = _predefinedAmounts[index].replaceAll(
                              '.',
                              '',
                            ); // Eliminar el punto para que sea un número entero
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0958B8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Mostramos el valor del botón con el simbolo de dólar
                        child: Text(
                          "\$${_predefinedAmounts[index]}",
                          style: const TextStyle(
                            color: Color(0xFF0958B8),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0958B8),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFC9C9C9),
        onTap: (index) {
          if (index != _selectedIndex) {
            if (index == 0) {
              // Navegación a la pantalla principal
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              // Para la pantalla de transferencias (aún no implementada)
              Navigator.pushReplacementNamed(context, '/transfers');
            }
            // No hacemos nada si el índice es 2 porque ya estamos en la pantalla de retiros
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
