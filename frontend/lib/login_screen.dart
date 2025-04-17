//Importaciones
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Widget con estado StatefulWidget para manejar datos dinamicos
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores de texto para los campos de identificación y clave
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Variables para manejar el estado de la visibilidad de la clave y la aceptación de términos
  bool _obscureText = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra superior azul con logo
          Container(
            // para que ocupe el 30% de la pantalla
            height: MediaQuery.of(context).size.height * 0.3,
            // el color de fondo azul
            color: const Color(0xFF0958B8),
            // Centro del contenido
            child: Center(
              // Animación de entrada desde abajo
              child: FadeInDown(
                duration: const Duration(milliseconds: 800),
                // Organizamos el contenido en una columna
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo del cajero automático
                    FaIcon(
                      FontAwesomeIcons.piggyBank,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          // Hacemos que el resto de la pantalla ocupe el espacio restante
          Expanded(
            //Establecemos el color de fondo blanco
            child: Container(
              color: Colors.white,
              // Permite el desplazamiento del contenido
              // para que no se corte en pantallas pequeñas
              child: SingleChildScrollView(
                // Agregamos una margen de 24 píxeles alrededor del contenido
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  // Alineamos el contenido a la izquierda
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Título principal
                    // Animación de entrada desde arriba
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: const Text(
                        "Ingresa a tu cajero automático",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0958B8),
                        ),
                      ),
                    ),
                    // espaciado entre el título y el subtítulo
                    const SizedBox(height: 30),

                    // Subtítulo "Identificación"
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: const Text(
                        "Identificación",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Campo número de identificación
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      // Agregamos un campo de texto para la identificación
                      child: TextFormField(
                        // Vinculamos el controlador de texto
                        // para obtener el valor ingresado
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: "Número de identificación",
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
                        // Establecemos el tipo de teclado
                        // para que solo acepte números
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo de clave
                    FadeInUp(
                      duration: const Duration(milliseconds: 1100),
                      child: TextFormField(
                        // Vinculamos el controlador de texto
                        // para obtener el valor ingresado
                        controller: _passwordController,
                        // ObscureText para ocultar la clave y mostrarla como puntos
                        obscureText: _obscureText,
                        // Personalizamos el campo de texto
                        decoration: InputDecoration(
                          labelText: "Clave",
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
                          // Icono de ojo para mostrar/ocultar la clave
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF0958B8),
                            ),
                            // Actualizamos el estado al presionar el icono
                            // para mostrar u ocultar la clave
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        // Establecemos el tipo de teclado
                        // para que solo acepte números
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Checkbox Términos y Condiciones
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      // ALineamos el checkbox y el texto en una fila
                      child: Row(
                        children: [
                          Checkbox(
                            // Reflejamos el estado del checkbox (true/false)
                            value: _acceptTerms,
                            // Establecemos el color del checkbox cuando está activo
                            activeColor: const Color(0xFF0958B8),
                            // Actualizamos _acceptTerms al cambiar el estado del checkbox
                            onChanged: (bool? value) {
                              setState(() {
                                _acceptTerms = value ?? false;
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
                    const SizedBox(height: 30),

                    // Botón de Ingresar
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      // Establecemos el boton con ancho completo con double.infinity y la altura de 50
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        // Boton de ingreso
                        child: ElevatedButton(
                          onPressed: () {
                            // Validar y redirigir al home
                            // si _acceptTerms es true
                            if (_acceptTerms) {
                              // Comprabamos que los campos no estén vacíos
                              if (_idController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                //Si es así, redirigimos al home
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                                // Si no, mostramos un mensaje de error
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Por favor completa todos los campos',
                                    ),
                                  ),
                                );
                              }
                              // Si el checkbox no está marcado, mostramos un mensaje de error
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Debes aceptar los términos y condiciones',
                                  ),
                                ),
                              );
                            }
                          },
                          // Establecemos el color de fondo y el color del texto
                          // del botón, el borde redondeado y la sombra
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0958B8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            "Ingresar ahora",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
