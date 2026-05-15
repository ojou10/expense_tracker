import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isPermissionDenied = false;
  bool _isCameraError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    // Check camera permission
    final status = await Permission.camera.status;

    if (status.isGranted) {
      await _setupCamera();
      return;
    }

    if (status.isPermanentlyDenied) {
      setState(() {
        _isPermissionDenied = true;
        _errorMessage = 'Camera permission is permanently denied. '
            'Please enable it in Settings.';
      });
      return;
    }

    // Request permission
    final result = await Permission.camera.request();

    if (result.isGranted) {
      await _setupCamera();
    } else if (result.isPermanentlyDenied) {
      setState(() {
        _isPermissionDenied = true;
        _errorMessage = 'Camera permission is permanently denied. '
            'Please enable it in Settings.';
      });
    } else {
      setState(() {
        _isPermissionDenied = true;
        _errorMessage = 'Camera access is required to capture receipt photos.';
      });
    }
  }

  Future<void> _setupCamera() async {
    try {
      _controller = CameraController(
        defaultCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      setState(() {
        _isPermissionDenied = false;
        _isCameraError = false;
      });
    } on CameraException catch (e) {
      setState(() {
        _isCameraError = true;
        _errorMessage = _getCameraErrorMessage(e.code);
      });
    }
  }

  String _getCameraErrorMessage(String code) {
    switch (code) {
      case 'CameraAccessDenied':
        return 'Camera access was denied.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      default:
        return 'Could not initialize camera: $code';
    }
  }

  void _openAppSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Receipt Photo')),
      body: _buildBody(),
      floatingActionButton: _isPermissionDenied || _isCameraError
          ? null
          : FloatingActionButton(
              onPressed: _takePicture,
              child: const Icon(Icons.camera_alt),
            ),
    );
  }

  Widget _buildBody() {
    // Permission denied — show error with settings button
    if (_isPermissionDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.no_photography,
                  size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _openAppSettings,
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Camera error — show retry
    if (_isCameraError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isCameraError = false;
                    _errorMessage = '';
                  });
                  _initCamera();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Loading or camera preview
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _controller != null) {
          return CameraPreview(_controller!);
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: Colors.orange),
                const SizedBox(height: 12),
                Text('Error: ${snapshot.error}',
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isCameraError = false;
                    });
                    _initCamera();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      await _initializeControllerFuture;
      final image = await controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, image.path);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take picture: ${e.description ?? e.code}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
