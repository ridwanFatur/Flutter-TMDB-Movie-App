import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tmdb_movie_app/core/utils/external_storage_helper.dart';
import 'package:tmdb_movie_app/widgets/dialog_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  static Future<File?> getImage(var source) async {
    if (await ExternalStorageHelper.requestPermission(Permission.storage) &&
        await ExternalStorageHelper.requestPermission(Permission.camera)) {
      final imagePicker = ImagePicker();
      final imagePickedFile = await imagePicker.pickImage(source: source);
      if (imagePickedFile != null) {
        return File(imagePickedFile.path);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<File?> getImageCropped(BuildContext context) async {
    ImageSource? imageSource = await showDialogPickImageSource(context);
    if (imageSource != null) {
      File? imageFile = await getImage(imageSource);
      if (imageFile != null) {
        File? croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          compressQuality: 70,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: '',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              showCropGrid: false,
              lockAspectRatio: true,
              hideBottomControls: true),
          iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: "",
              rotateButtonsHidden: true,
              aspectRatioPickerButtonHidden: true),
        );

        if (croppedFile != null) {
          return croppedFile;
        }
      }
    }
  }
}
