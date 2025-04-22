// Importaciones necesarias para el funcionamiento del código
import 'package:cajero_app/service/service.dart'; // Importa el servicio ApiService para manejar las solicitudes al backend
import 'package:flutter/material.dart'; // Importa el framework Flutter para construir la interfaz de usuario
import 'package:animate_do/animate_do.dart'; // Importa la librería animate_do para agregar animaciones a los widgets
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importa FontAwesome para usar íconos personalizados

// Definimos un StatefulWidget para manejar un estado dinámico en la pantalla de login
class LoginScreen extends StatefulWidget {
  // Constructor constante con una clave opcional para identificar el widget
  const LoginScreen({Key? key}) : super(key: key);

  // Creamos el estado asociado al widget
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Clase que contiene el estado y la lógica de LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar el texto ingresado en los campos de correo y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables para manejar el estado de la pantalla
  bool _obscureText = true; // Controla si la contraseña se muestra como texto oculto (puntos) o visible
  bool _acceptTerms = false; // Indica si el usuario ha aceptado los términos y condiciones
  bool _isLoading = false; // Indica si se está procesando el inicio de sesión (para mostrar un indicador de carga)

  // Instancia de ApiService para realizar solicitudes al backend
  final ApiService _apiService = ApiService();

  // Método para manejar el proceso de inicio de sesión
  Future<void> _handleLogin() async {
    // Validar que los términos y condiciones hayan sido aceptados
    if (!_acceptTerms) {
      // Si no se aceptaron, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
        ),
      );
      return; // Salir del método
    }

    // Validar que los campos de correo y contraseña no estén vacíos
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Si alguno está vacío, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return; // Salir del método
    }

    // Cambiar el estado para indicar que se está procesando el inicio de sesión
    setState(() {
      _isLoading = true; // Mostrar un indicador de carga
    });

    try {
      // Llamar al método login de ApiService para autenticar al usuario
      final response = await _apiService.login(
        _emailController.text, // Correo ingresado por el usuario
        _passwordController.text, // Contraseña ingresada por el usuario
      );

      // Verificar si el inicio de sesión fue exitoso
      if (response['success'] == true) {
        // Extraer el ID del usuario de la respuesta del backend
        final userId = response['id'];

        // Navegar a la pantalla principal (HomeScreen) y pasar el userId como argumento
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: userId, // Pasar el ID para usarlo en otras pantallas
        );
      } else {
        // Si las credenciales son incorrectas, mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas. Intenta de nuevo.'),
          ),
        );
      }
    } catch (e) {
      // Manejar errores de conexión o del servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: ${e.toString()}')),
      );
    } finally {
      // Finalizar el estado de carga, independientemente de si hubo éxito o error
      setState(() {
        _isLoading = false; // Ocultar el indicador de carga
      });
    }
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cuerpo principal de la pantalla, organizado en una columna
      body: Column(
        children: [
          // Barra superior azul con el logo
          Container(
            // Ocupa el 30% de la altura de la pantalla
            height: MediaQuery.of(context).size.height * 0.3,
            // Fondo azul
            color: const Color(0xFF0958B8),
            // Centra el contenido dentro del contenedor
            child: Center(
              // Animación de entrada desde arriba hacia abajo
              child: FadeInDown(
                duration: const Duration(milliseconds: 800), // Duración de la animación
                // Contenido organizado en una columna
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícono de un cajero automático (piggy bank)
                    FaIcon(
                      FontAwesomeIcons.piggyBank,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10), // Espacio entre el ícono y el siguiente elemento
                  ],
                ),
              ),
            ),
          ),

          // Contenedor que ocupa el resto de la pantalla
          Expanded(
            // Fondo blanco
            child: Container(
              color: Colors.white,
              // Permite desplazamiento para evitar que el contenido se corte en pantallas pequeñas
              child: SingleChildScrollView(
                // Margen de 24 píxeles alrededor del contenido
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  // Alineamos el contenido a la izquierda
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Espacio inicial

                    // Título principal con animación de entrada desde abajo hacia arriba
                    FadeInUp(
                      duration: const Duration(milliseconds: 800), // Duración de la animación
                      child: const Text(
                        "Ingresa a tu cajero automático",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0958B8), // Color azul
                        ),
                      ),
                    ),
                    // Espacio entre el título y el subtítulo
                    const SizedBox(height: 30),

                    // Subtítulo "Correo electrónico" con animación de entrada
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: const Text(
                        "Correo electrónico",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15), // Espacio entre el subtítulo y el campo

                    // Campo de texto para ingresar el correo electrónico
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: TextFormField(
                        controller: _emailController, // Vincula el controlador para capturar el texto
                        decoration: InputDecoration(
                          labelText: "Correo electrónico", // Etiqueta del campo
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
                        keyboardType: TextInputType.emailAddress, // Teclado optimizado para correos
                      ),
                    ),
                    const SizedBox(height: 20), // Espacio entre campos

                    // Campo de texto para ingresar la contraseña
                    FadeInUp(
                      duration: const Duration(milliseconds: 1100),
                      child: TextFormField(
                        controller: _passwordController, // Vincula el controlador para capturar la contraseña
                        obscureText: _obscureText, // Oculta el texto de la contraseña (muestra puntos)
                        decoration: InputDecoration(
                          labelText: "Clave", // Etiqueta del campo
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
                          // Ícono para mostrar u ocultar la contraseña
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off // Ícono de ojo cerrado
                                  : Icons.visibility, // Ícono de ojo abierto
                              color: const Color(0xFF0958B8),
                            ),
                            // Cambia el estado de visibilidad al presionar el ícono
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText; // Alterna entre mostrar y ocultar
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.text, // Teclado para texto
                      ),
                    ),
                    const SizedBox(height: 20), // Espacio entre campos

                    // Checkbox para aceptar términos y condiciones
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms, // Estado actual del checkbox
                            activeColor: const Color(0xFF0958B8), // Color azul cuando está marcado
                            onChanged: (bool? value) {
                              setState(() {
                                _acceptTerms = value ?? false; // Actualiza el estado al cambiar
                              });
                            },
                          ),
                          const Text(
                            "Acepto los términos y condiciones",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30), // Espacio antes del botón

                    // Botón para iniciar sesión
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: SizedBox(
                        width: double.infinity, // Ocupa todo el ancho disponible
                        height: 50, // Altura fija del botón
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _handleLogin, // Desactiva el botón mientras se procesa el login
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
                                  strokeWidth: 2,
                                ) // Indicador de carga mientras se procesa
                              : const Text(
                                  "Ingresar ahora",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), // Texto del botón
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}