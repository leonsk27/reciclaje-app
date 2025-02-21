import 'package:best_flutter_ui_templates/fitness_app/ui_view/escaneado_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/resultado_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  int _selectedCameraIndex = 0;
  XFile? _capturedImage;
  bool _isScanning = false;
  bool _showResults = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Mostrar diálogo para solicitar activar el servicio de ubicación
      _showLocationServiceDialog();
      return;
    }

    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Mostrar mensaje si el usuario negó los permisos
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Mostrar mensaje si el usuario negó los permisos permanentemente
      _showPermissionDeniedForeverDialog();
      return;
    }

    // Si tenemos permisos, obtener la ubicación
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Servicio de Ubicación'),
        content: Text('Por favor active el servicio de ubicación para continuar.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Permisos Denegados'),
        content: Text('Se requieren permisos de ubicación para usar esta función.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Permisos Denegados Permanentemente'),
        content: Text('Por favor habilite los permisos de ubicación en la configuración.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
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
        _startScanning(image);
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
        _startScanning(image);
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  void _startScanning(XFile image) {
    setState(() {
      _capturedImage = image;
      _isScanning = true;
    });
  }

  void _flipCamera() {
    if (cameras.length > 1) {
      setState(() {
        _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;
        _initializeCamera();
      });
    }
  }

  void _handleScanComplete(XFile image) {
    setState(() {
      _isScanning = false;
      _showResults = true;
    });
  }

  void _resetCamera() {
    setState(() {
      _capturedImage = null;
      _isScanning = false;
      _showResults = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si estamos escaneando, mostrar la pantalla de escaneo
    if (_isScanning && _capturedImage != null) {
      return ScanningScreen(
        image: _capturedImage!,
        onScanComplete: _handleScanComplete,
      );
    }

    // Si tenemos resultados, mostrar la pantalla de resultados
    if (_showResults && _capturedImage != null) {
      return ResultsScreen(
        image: _capturedImage!,
        onRetry: _resetCamera,
        location: _currentPosition, // Pasar la ubicación a ResultsScreen
      );
    }

    // Pantalla principal de la cámara
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