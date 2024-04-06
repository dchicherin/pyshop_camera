import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pyshop_camera/photo_data.dart';

class CameraScreenUtils {
  CameraScreenUtils();

  Future<List<double>> getCurrentCoordinates() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print("Service disabled");
        }
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      return [position.latitude, position.longitude];
    } catch (e) {
      return [0, 0];
    }
  }

  void uploadPhotoWithComment(PhotoData photoData) {
    var url = Uri.https(
      '2718ef02-bda8-4c69-8f10-af8bea9ea139.mock.pstmn.io',
      'upload_photo/',
    );

    final request = http.MultipartRequest("POST", url);
    request.fields.addAll({
      'comment': photoData.comment,
      'latitude': photoData.latitude.toString(),
      'longitude': photoData.longitude.toString(),
    });
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      photoData.bytePicture,
      filename: photoData.fileName,
    ));
    request.send();
  }
}
