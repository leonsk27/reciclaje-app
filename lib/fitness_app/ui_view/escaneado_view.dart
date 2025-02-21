import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanningScreen extends StatefulWidget {
  final XFile image;
  final Function(XFile) onScanComplete;
  
  const ScanningScreen({
    Key? key,
    required this.image,
    required this.onScanComplete,
  }) : super(key: key);

  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> with TickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _scanLineAnimation;
  // bool _shouldComplete = false;
  int _scanCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),  // Reducimos la duración para que sea más rápido
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_scanAnimationController);

    // Animación que va de 0 a 1 y luego de 1 a 0
    _scanLineAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.linear,
      ),
    );

    // Manejador cuando la animación completa un ciclo
    _scanAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scanAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _scanCount++;
        if (_scanCount >= 3) {  // Después de 3 ciclos completos
          widget.onScanComplete(widget.image);
        } else {
          _scanAnimationController.forward();
        }
      }
    });

    // Iniciar la animación
    _scanAnimationController.forward();
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen capturada
          Image.file(
            File(widget.image.path),
            fit: BoxFit.cover,
          ),
          
          // Overlay semi-transparente
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Línea de escaneo animada
          AnimatedBuilder(
            animation: _scanLineAnimation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * _scanLineAnimation.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Colors.green,
                ),
              );
            },
          ),

          // Texto e indicador de progreso
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: (_scanCount * 2 + _scanAnimation.value) / 6,  // Progreso total basado en los ciclos
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  "Escaneando residuo...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}