import 'package:best_flutter_ui_templates/fitness_app/controllers/auth_controller.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
        body: Stack(
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
              'Hola\nInicia sesión!',
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
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: authController.emailController,
                    decoration: const InputDecoration(
                      label: Text('Correo',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Color.fromARGB(255, 23, 44, 184),
                      ),)
                    ),
                  ),
                  TextField(
                    controller: authController.passwordController,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                        label: Text('Contraseña',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:Color.fromARGB(255, 23, 44, 184),
                        ),)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Has olvidado tu contraseña?',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xff281537),
                    ),),
                  ),
                  const SizedBox(height: 80,),
                  GestureDetector(
                    onTap: () {
                      authController.login();
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
                      child: const Center(child: Text('INICIAR SESIÓN',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      authController.loginWithGoogle();
                    },
                    child: Container(
                      height: 55,
                      width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color.fromARGB(255, 23, 44, 184)),
                    ),
                    child: const Center(child: Text('INICIAR CON GOOGLE',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 23, 44, 184)
                    ),
                  ),
                )
              ),
            ),
                const SizedBox(height: 130,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "No tengo cuenta?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignUpPage());
                        },
                        child: const Text(
                          "Registrarse",
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
