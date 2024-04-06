import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'camera_screen.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<CameraDescription> cameras = await availableCameras();

  runApp(MaterialApp(
    home: CameraScreen(
      cameras: cameras,
    ),
  ));
}
