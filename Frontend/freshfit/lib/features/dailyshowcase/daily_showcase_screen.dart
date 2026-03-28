import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);

class ThreeDPage extends StatelessWidget {
  const ThreeDPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: const Text(
                '3D Viewer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: _kAccent,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
            ),

            // Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              height: 2,
              color: _kAccent,
            ),

            const SizedBox(height: 14),

            // Model viewer inside bordered container
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: _kAccent, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: ModelViewer(
  src: 'asset:assets/singh.glb',
  alt: 'A 3D model',
  ar: true,
  autoRotate: true,
  cameraControls: true,
  backgroundColor: _kBg,
  relatedJs: "asset:assets/model-viewer.min.js",
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}