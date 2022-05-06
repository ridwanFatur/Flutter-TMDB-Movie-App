import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/database_helper.dart';
import 'package:tmdb_movie_app/core/utils/image_convert_helper.dart';
import 'package:tmdb_movie_app/core/utils/image_picker_helper.dart';
import 'package:tmdb_movie_app/core/utils/local_database_config.dart';
import 'package:tmdb_movie_app/models/user.dart';
import 'package:sembast/sembast.dart';

class ProfileProvider extends ChangeNotifier {
  late User user;
  String? errorName;
  String? errorBirthDate;
  String? errorBirthPlace;

  ProfileProvider() {
    user = User();
    initProfile();
  }

  void initProfile() async {
    Database db = await LocalDatabase.instance.database;
    var store = StoreRef.main();
    var json = await store.record(SembastConfig.kProfileKey).get(db);
    User? user;
    if (json != null) {
      try {
        Map<String, dynamic> data = jsonDecode(json);
        user = User.fromMap(data);
      } catch (e) {
        user = null;
      }
    }

    if (user != null) {
      File? imageFile;
      if (user.imageProfileBase64 != null) {
        imageFile =
            await ImageConvertHelper.decodeImage(user.imageProfileBase64!);
      }
      user.imageProfile = imageFile;
      this.user = user.copy();
      notifyListeners();
    }
  }

  void changeProfile(User user) {
    this.user = user.copy();
    notifyListeners();
  }

  void verifyUserProfile({
    required String name,
    required DateTime? birthDate,
    required String birthPlace,
    required VoidCallback nextAction,
  }) {
    errorName = null;
    errorBirthDate = null;
    errorBirthPlace = null;

    if (name.isEmpty) {
      errorName = "Name Cannot be empty";
    }
    if (birthDate == null) {
      errorBirthDate = "Birth Date Cannot be empty";
    }
    if (birthPlace.isEmpty) {
      errorBirthPlace = "Birth Place Cannot be empty";
    }
    notifyListeners();
    if (errorName == null &&
        errorBirthDate == null &&
        errorBirthPlace == null) {
      User user = User(
        name: name,
        birthDate: birthDate,
        birthPlace: birthPlace,
        imageProfile: this.user.imageProfile,
      );
      changeProfile(user);
      updateLocalDatabase(user);
      nextAction();
    }
  }

  void updateLocalDatabase(User user) async {
    Database db = await LocalDatabase.instance.database;
    var store = StoreRef.main();
    String json = await user.toJson();
    await store.record(SembastConfig.kProfileKey).put(db, json);
  }

  void changeImageProfile(BuildContext context) async {
    File? imageFileCropped = await ImagePickerHelper.getImageCropped(context);
    if (imageFileCropped != null) {
      User userUpdated = user.copy();
      userUpdated.imageProfile = imageFileCropped;
      updateLocalDatabase(userUpdated);
      user = userUpdated;
      notifyListeners();
    }
  }
}
