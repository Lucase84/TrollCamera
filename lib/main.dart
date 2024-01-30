import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:troll_camera/views/camera_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<CameraDescription> cameras = await availableCameras();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: <SystemUiOverlay>[],
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraView(
        cameras: cameras,
      ),
    ),
  );
}
