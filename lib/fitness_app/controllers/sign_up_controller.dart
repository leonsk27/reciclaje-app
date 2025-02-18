import 'package:best_flutter_ui_templates/fitness_app/ui_view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    setLoading(true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Guardar datos en Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario registrado: ${userCredential.user!.email}")),
      );
      Get.off(() => LoginPage());


      // Limpiar campos después del registro
      nameController.clear();
      emailController.clear();
      passwordController.clear();

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error desconocido";
      if (e.code == 'weak-password') {
        errorMessage = "La contraseña es demasiado débil.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "El correo ya está en uso.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "El correo es inválido.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setLoading(false);
    }
  }
}
