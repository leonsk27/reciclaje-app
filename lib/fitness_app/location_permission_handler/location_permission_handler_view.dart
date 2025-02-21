import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionHandler extends StatefulWidget {
  final Widget child;

  const LocationPermissionHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<LocationPermissionHandler> createState() => _LocationPermissionHandlerState();
}

class _LocationPermissionHandlerState extends State<LocationPermissionHandler> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _error = 'Los servicios de ubicación están desactivados. Por favor, actívalos para continuar.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _error = 'Los permisos de ubicación fueron denegados';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _error = 'Los permisos de ubicación están permanentemente denegados. Por favor, habilítalos en la configuración.';
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error al solicitar permisos de ubicación: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Verificando permisos de ubicación...'),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _error = null;
                      });
                      _checkAndRequestPermission();
                    },
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}