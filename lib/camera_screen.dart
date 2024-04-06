import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pyshop_camera/photo_data.dart';
import 'package:pyshop_camera/utilities.dart';

class CameraScreen extends StatefulWidget {
  List<CameraDescription> cameras;
  CameraScreen({super.key, required this.cameras});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  double? latitude;
  double? longitude;
  String _messageToSend = "";
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: Text("Камера недоступна"),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _textController,
                    onChanged: (text) {
                      _messageToSend = text;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Введите описание',
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.camera,
                  size: 60,
                ),
                onPressed: () async {
                  String myComment = _messageToSend;
                  _textController.clear();
                  _messageToSend = "";
                  List<double> coordinates =
                      await CameraScreenUtils().getCurrentCoordinates();
                  latitude = coordinates[0];
                  longitude = coordinates[1];
                  XFile picture = await _controller.takePicture();
                  Uint8List bytePicture = await picture.readAsBytes();
                  String fileName = picture.path;
                  PhotoData dataToSend = PhotoData(
                    bytePicture: bytePicture,
                    longitude: longitude!,
                    latitude: latitude!,
                    comment: myComment,
                    fileName: fileName,
                  );
                  CameraScreenUtils().uploadPhotoWithComment(dataToSend);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
