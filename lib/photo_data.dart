import 'dart:typed_data';

class PhotoData {
  double latitude;
  double longitude;
  Uint8List bytePicture;
  String fileName;
  String comment;
  PhotoData({
    required this.bytePicture,
    required this.longitude,
    required this.latitude,
    required this.comment,
    required this.fileName,
  });
}
