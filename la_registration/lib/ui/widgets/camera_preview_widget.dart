import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;
  final void Function(CameraImage image) onPreviewFrame;

  const CameraPreviewWidget({
    super.key, // Добавляем параметр key
    required this.camera,
    required this.onPreviewFrame,
  }); // Передаем key в конструктор родительского класса

  @override
  CameraPreviewWidgetState createState() => CameraPreviewWidgetState();
}

class CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) return;
      _controller.startImageStream(widget.onPreviewFrame);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
