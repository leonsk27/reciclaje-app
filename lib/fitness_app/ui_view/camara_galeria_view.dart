import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  int _selectedCameraIndex = 0;
  XFile? capturedImage;
  bool isScanning = false;
  bool showResults = false;
  
  AnimationController? _scanAnimationController;
  Animation<double>? _scanAnimation;
  Animation<double>? _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimations();
  }
    void _initializeAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_scanAnimationController!);

    _scanLineAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _scanAnimationController!,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isScanning = false;
          showResults = true;
        });
      }
    });
  }

  void _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[_selectedCameraIndex], 
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller?.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print("Error al inicializar la cámara: $e");
    }
  }

  Future<void> _takePicture() async {
    if (!mounted) return;
    
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        print("Controlador de cámara no inicializado");
        return;
      }

      final XFile? image = await _controller?.takePicture();
      if (image != null) {
        setState(() {
          capturedImage = image;
          isScanning = true;
        });
        _scanAnimationController?.forward();
      }
    } catch (e) {
      print("Error al tomar la foto: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        setState(() {
          capturedImage = image;
          isScanning = true;
        });
        _scanAnimationController?.forward();
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  void _flipCamera() {
    if (cameras.length > 1) {
      setState(() {
        _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;
        _initializeCamera();
      });
    }
  }

  void _resetCamera() {
    setState(() {
      capturedImage = null;
      isScanning = false;
      showResults = false;
      _scanAnimationController?.reset();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanAnimationController?.dispose();
    super.dispose();
  }

  Widget _buildScanningView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen capturada a pantalla completa
          if (capturedImage != null)
            Image.file(
              File(capturedImage!.path),
              fit: BoxFit.cover,
            ),
          
          // Overlay semi-transparente
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Animación de escaneo
          if (_scanLineAnimation != null)
            AnimatedBuilder(
              animation: _scanLineAnimation!,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * _scanLineAnimation!.value,
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
                if (_scanAnimation != null)
                  CircularProgressIndicator(
                    value: _scanAnimation!.value,
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

  Widget _buildResultsView() {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (capturedImage != null)
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
                  File(capturedImage!.path),
                    fit: BoxFit.cover,
                  ),
              ),
            ),
          SizedBox(height: 20),
          Text(
            "Resultados del escaneo",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                  "Recomendación: Depositar en contenedor amarillo",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _resetCamera,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              "Repetir escaneo",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isScanning) {
      return Scaffold(body: _buildScanningView());
    }
    if (showResults) {
      return Scaffold(body: _buildResultsView());
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Text(
              "Coloque el residuo en foco",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.image, size: 30, color: Colors.green),
                  onPressed: _pickImage,
                ),
                SizedBox(width: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 3),
                      ),
                    ),
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 40),
                IconButton(
                  icon: Icon(Icons.refresh, size: 30, color: Colors.green),
                  onPressed: _flipCamera,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}