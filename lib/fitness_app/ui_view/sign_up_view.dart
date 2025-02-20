import 'package:best_flutter_ui_templates/fitness_app/controllers/sign_up_controller.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
 Widget build(BuildContext context) {
    final SignUpController authController = Get.put(SignUpController());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(255, 23, 184, 63),
                        Color.fromARGB(255, 19, 54, 24),
                      ],
                      center: Alignment.center,
                      radius: 0.7,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: const [
                  Text(
                    'Crea',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Tu Cuenta',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: 360,
              margin: const EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: authController.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 23, 184, 63),
                      ),
                    ),
                  ),
                  TextField(
                    controller: authController.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 23, 184, 63),
                      ),
                    ),
                  ),
                  TextField(
                    controller: authController.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 23, 184, 63),
                      ),
                      suffixIcon: Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      authController.register(context);
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: RadialGradient(
                          colors: [
                            Color.fromARGB(255, 23, 184, 63),
                            Color.fromARGB(255, 19, 54, 24),
                          ],
                          center: Alignment.center,
                          radius: 2.3,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'REGISTRAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  GestureDetector( 
                    onTap: () {
                      Get.to(() => LoginPage());
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Iniciar Sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}