import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/login_view.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<User?> usuario = Rx<User?>(null);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    usuario.bindStream(auth.authStateChanges());
    super.onInit();
  }

  // Ingreso por correo electrónico y contraseña
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Por favor, completa todos los campos",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (auth.currentUser != null) {
        Get.off(() => FitnessAppHomeScreen());
      } else {
        Get.snackbar("Error", "Credenciales incorrectas",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  // Ingreso con Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Get.snackbar("Error", "Inicio de sesión cancelado",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión con las credenciales de Google
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Get.off(() => FitnessAppHomeScreen());
      } else {
        Get.snackbar("Error", "No se pudo iniciar sesión con Google",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await auth.signOut();
    googleSignIn.signOut();
    Get.offAll(() => LoginPage());
  }

  // Manejo de errores de autenticación
  void _handleAuthError(FirebaseAuthException e) {
    String mensaje = "Error desconocido";

    switch (e.code) {
      case "invalid-email":
        mensaje = "El correo ingresado no es válido.";
        break;
      case "user-not-found":
      case "wrong-password":
        mensaje = "Correo o contraseña incorrectos.";
        break;
      case "user-disabled":
        mensaje = "Esta cuenta ha sido deshabilitada.";
        break;
      default:
        mensaje = "Ocurrió un error: ${e.message}";
    }

    Get.snackbar("Error", mensaje, backgroundColor: Colors.red, colorText: Colors.white);
  }
}
