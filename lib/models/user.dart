import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tmdb_movie_app/core/utils/image_convert_helper.dart';

class User {
  String? name;
  DateTime? birthDate;
  String? birthPlace;
  File? imageProfile;
  String? imageProfileBase64;

  User({
    this.name,
    this.birthDate,
    this.birthPlace,
    this.imageProfile,
    this.imageProfileBase64,
  });

  String? get birthDateFormatted {
    if (birthDate != null) {
      return DateFormat("dd MMMM yyyy").format(birthDate!);
    }
  }

  Future<Map<String, dynamic>> toMap() async {
    String? base64Image;
    if (imageProfile != null) {
      base64Image = await ImageConvertHelper.encodeImage(imageProfile!);
    }

    return {
      "name": name,
      "birth_place": birthPlace,
      "birth_date": birthDate != null
          ? DateFormat("yyyy-MM-dd").format(birthDate!)
          : null,
      "image_profile": base64Image,
    };
  }

  User copy() {
    return User(
      name: name,
      birthPlace: birthPlace,
      birthDate: birthDate,
      imageProfile: imageProfile,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    DateTime? birthDate;
    if (map["birth_date"] != null) {
      try {
        birthDate = DateFormat("yyyy-MM-dd").parse(map["birth_date"]);
      } catch (e) {
        birthDate = null;
      }
    }

    return User(
      name: map["name"],
      birthDate: birthDate,
      birthPlace: map["birth_place"],
      imageProfileBase64: map["image_profile"],
    );
  }

  Future<String> toJson() async {
    Map<String, dynamic> data = await toMap();
    return json.encode(data);
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
