import 'package:flutter/material.dart';
import 'package:troll_camera/views/camera_view.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraView(
        camera: cameras.first,
      ),
    ),
  );
}
