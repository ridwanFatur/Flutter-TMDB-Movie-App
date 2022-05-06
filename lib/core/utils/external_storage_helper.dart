import 'dart:io';
import 'package:tmdb_movie_app/widgets/show_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExternalStorageHelper {
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static Future<void> saveExternalStorageFile(
      String folder, String fileName, File file) async {
    Directory? directory;

    try {
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String pathName = getNormalizeFileName(directory!) + "/$folder";
          directory = Directory(pathName);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          File saveFile = File(directory.path + "/$fileName");
          if (await directory.exists()) {
            var body = await file.readAsBytes();
            await saveFile.writeAsBytes(body);
            await saveFile.create(recursive: true);
            showToast("Save File Success");
          }
        }
      } else if (Platform.isIOS) {}
    } catch (e) {
      showToast("Something is wrong");
    }
  }

  static String getNormalizeFileName(Directory directory) {
    String newPath = "";
    List<String> paths = directory.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    return newPath;
  }
}
