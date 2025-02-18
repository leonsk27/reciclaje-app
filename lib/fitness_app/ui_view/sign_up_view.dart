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
        body: Stack(//thanks for watching
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 23, 44, 184),
                  Color.fromARGB(255, 21, 26, 55),
                ]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Crea tu\nCuenta',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child:  Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: authController.nameController,
                        decoration: InputDecoration(
                            // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Nombre Completo',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 23, 44, 184),
                            ),)
                        ),
                      ),
                      TextField(
                        controller: authController.emailController,
                        decoration: InputDecoration(
                            // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Correo',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 23, 44, 184),
                            ),)
                        ),
                      ),
                      TextField(
                        controller: authController.passwordController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                            label: Text('Contraseña',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 23, 44, 184),
                            ),)
                        ),
                      ),
                      const SizedBox(height: 80,),
                  GestureDetector(
                    onTap: () {
                      authController.register(context);
                    },
                    child: Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 23, 44, 184),
                            Color.fromARGB(255, 21, 26, 55),
                          ]
                        ),
                      ),
                      child: const Center(child: Text('REGISTRAR',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),),),
                    ),
                  ),
                      const SizedBox(height: 180,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Ya tengo una cuenta.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => LoginPage()); // Redirige a la página de inicio de sesión
                            },
                            child: const Text(
                              "Iniciar Sesión",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}