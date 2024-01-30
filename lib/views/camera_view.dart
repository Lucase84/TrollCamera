import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:troll_camera/views/display_picture.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

class CameraView extends StatefulWidget {
  const CameraView({required this.cameras, super.key});

  final List<CameraDescription> cameras;
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _cameraIndex = 0;
  String lastPicturePath = '';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCamera() {
    setState(() {
      _cameraIndex = _cameraIndex == 0 ? 1 : 0;
      _controller = CameraController(
        widget.cameras[_cameraIndex],
        ResolutionPreset.max,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  void _takePicture() async {
    try {
      CameraController controller = CameraController(
        widget.cameras.last,
        ResolutionPreset.max,
      );
      await controller.initialize();
      final image = await controller.takePicture();
      await GallerySaver.saveImage(
        image.path,
        albumName: 'Troll Camera',
      );
      lastPicturePath = image.path;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _displayLastPicture() async {
    if (lastPicturePath.isNotEmpty) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: lastPicturePath,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: CameraPreview(_controller),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        _rowOfButtons(),
      ],
    );
  }

  Widget _rowOfButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _displayLastPicture,
              iconSize: 25,
              color: Colors.white,
              icon: const Icon(Icons.image_rounded),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(100, 0, 0, 0),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(width: 3, color: Colors.white),
                  left: BorderSide(width: 3, color: Colors.white),
                  right: BorderSide(width: 3, color: Colors.white),
                  bottom: BorderSide(width: 3, color: Colors.white),
                ),
              ),
              child: IconButton(
                onPressed: _takePicture,
                color: Colors.transparent,
                icon: const Icon(Icons.circle),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.all(10),
              onPressed: _flipCamera,
              iconSize: 25,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(100, 0, 0, 0),
                ),
                iconColor: MaterialStateProperty.all(Colors.white),
              ),
              icon: const Icon(Icons.flip_camera_android_outlined),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
