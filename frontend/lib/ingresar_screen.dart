import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cajero_app/service/service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _selectedIndex = 1; // Inicializado en 1 para el botón de transferencia
  final TextEditingController _amountController = TextEditingController();
  final ApiService _apiService = ApiService(); // Instancia del ApiService
  bool _isLoading = false; // Control del estado de carga
  int? userId;

  // Valores predefinidos para los botones de transferencia
  final List<String> _predefinedAmounts = [
    '20.000',
    '50.000',
    '100.000',
    '200.000',
    '300.000',
    '400.000',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = ModalRoute.of(context)!.settings.arguments as int?;
      print('User ID recibido: $userId');
      if (userId == null) {
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
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese un valor a depositar')),
      );
      return;
    }

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se identificó al usuario')),
      );
      return;
    }

    // Convertir el texto a double para el monto
    double amount;
    try {
      String amountText = _amountController.text.replaceAll('.', '');
      amount = double.parse(amountText);
      print('Monto a depositar: $amount');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese un valor numérico válido'),
        ),
      );
      return;
    }

    // Verificar que el monto sea positivo
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El monto debe ser mayor a cero')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Llamar al método ingresarSaldo de ApiService
      String result = await _apiService.ingresarSaldo(userId!, amount);

      // Verificar si la operación fue exitosa
      if (result.contains('exitoso') || !result.contains('Error')) {
        // Mostrar modal de depósito exitoso
        showDialog(
          context: context,
          barrierDismissible: false, // El usuario debe usar un botón para salir
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 10),
                  Text(
                    "¡Depósito Exitoso!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0958B8),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
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
                TextButton(
                  onPressed: () {
                    // Limpiar el campo y cerrar el diálogo (para realizar otro depósito)
                    _amountController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Realizar otro depósito",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Cerrar el diálogo y regresar a la pantalla principal
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                      arguments: userId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0958B8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Volver al Inicio"),
                ),
              ],
            );
          },
        );
      } else {
        // Mostrar mensaje de error con SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Manejar cualquier error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en la conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          "Depósito",
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
              // Tarjeta principal para la transferencia
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
                        "Depósito a cuenta",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0958B8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Ingrese el valor a depositar:",
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
                      // Botón de confirmar transferencia
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _processDeposit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0958B8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                    itemCount: _predefinedAmounts.length,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                        onPressed: () {
                          setState(() {
                            // Establecer el valor del botón en el campo de texto
                            _amountController.text = _predefinedAmounts[index]
                                .replaceAll('.', '');
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0958B8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
        backgroundColor: const Color(0xFF0958B8),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFC9C9C9),
        onTap: (index) {
          if (index != _selectedIndex) {
            if (index == 0) {
              // Navegación a la pantalla principal con el ID del usuario
              Navigator.pushReplacementNamed(
                context,
                '/home',
                arguments: userId,
              );
            } else if (index == 2) {
              // Navegación a la pantalla de retiros con el ID del usuario
              Navigator.pushReplacementNamed(
                context,
                '/withdrawals',
                arguments: userId,
              );
            }
            // No hacemos nada si el índice es 1 porque ya estamos en la pantalla de transferencias
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
