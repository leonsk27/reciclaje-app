import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsScreen extends StatelessWidget {
  final XFile image;
  final VoidCallback onRetry;
  final Position? location;

  const ResultsScreen({
    Key? key,
    required this.image,
    required this.onRetry,
    this.location,
  }) : super(key: key);

  Future<void> saveToFirebase() async {
    try {
      // 1️⃣ Subir imagen a Firebase Storage
      File file = File(image.path);
      String fileName = "images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(fileName).putFile(file);
      String imageUrl = await snapshot.ref.getDownloadURL();

      // 2️⃣ Guardar datos en Firestore
      await FirebaseFirestore.instance.collection("scans").add({
        "imageUrl": imageUrl,
        "tipoResiduo": "Plástico",
        "categoria": "Reciclable",
        "recomendacion": "Depositar en contenedor rojo",
        "ubicacion": location != null
            ? {"latitud": location!.latitude, "longitud": location!.longitude}
            : null,
        // "timestamp": FieldValue.serverTimestamp(),
      });

      print("✅ Datos guardados en Firebase");
    } catch (e) {
      print("❌ Error al guardar en Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Resultados del escaneo",
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tipo de residuo: Plástico",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Categoría: Reciclable",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Recomendación: Depositar en contenedor rojo",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "Ubicación: ${location?.latitude}, ${location?.longitude}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await saveToFirebase();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Notificar",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
