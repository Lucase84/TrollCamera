import 'dart:io';

import 'package:flutter/material.dart';

/// The screen that displays the picture taken by the camera
class DisplayPictureScreen extends StatelessWidget {
  /// Constructor for the display picture screen that takes the path of the image
  const DisplayPictureScreen({required this.imagePath, super.key});

  /// The path of the image to display
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      child: Image(
        image: FileImage(
          File(imagePath),
        ),
      ),
    );
  }
}
