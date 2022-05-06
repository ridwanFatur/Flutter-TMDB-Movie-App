import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/random_helper.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ImageConvertHelper {
  static Future<String> encodeImage(File imageFile) async {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static Future<File> decodeImage(String base64Image) async {
    Uint8List bytes = base64.decode(base64Image);
    String tempPath = (await getTemporaryDirectory()).path;
    var file = File('$tempPath/${RandomHelper.getRandomString(10)}.jpg');
    file.writeAsBytesSync(bytes);
    return file;
  }

  Future<Image> decodeImageAsImage(String base64Image) async {
    return Image.memory(base64Decode(base64Image));
  }

  Future<Uint8List> decodeImageAsUint8List(String base64Image) async {
    return base64Decode(base64Image);
  }
}
