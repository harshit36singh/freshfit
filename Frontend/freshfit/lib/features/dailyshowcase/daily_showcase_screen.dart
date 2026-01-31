import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDPage extends StatelessWidget {
  const ThreeDPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Model Viewer'),
        backgroundColor: Colors.black87,
      ),
      body: ModelViewer(
        src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        alt: 'A 3D model',
        ar: true,
        autoRotate: true,
        cameraControls: true,
      ),
    );
  }
}
