import 'dart:convert';
import 'dart:io';
import 'package:tmdb_movie_app/core/utils/api_url.dart';
import 'package:tmdb_movie_app/models/http_response.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  static String invalidResponse =
      'Invalid response received from server!\nPlease try again in a minute.';
  static String unableToReach =
      'Unable to reach the internet!\nPlease try again in a minute.';
  static String somethingWrong =
      'Something went wrong!\nPlease try again in a minute.';

  static Future<HTTPResponse> get(
    http.Client client,
    String url,
    Map<String, dynamic> parameter,
  ) async {
    Uri uri = Uri.parse(url);
    parameter["api_key"] = ApiUrl.kApiKey;
    final Uri newUri = uri.replace(queryParameters: parameter);
    var headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await client.get(newUri, headers: headers);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return HTTPResponse(
          data: body,
          isSuccessful: true,
          responseCode: response.statusCode,
          message: null,
        );
      } else {
        return HTTPResponse(
          isSuccessful: false,
          data: null,
          message: invalidResponse,
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      return HTTPResponse(
        isSuccessful: false,
        data: null,
        message: unableToReach,
      );
    } on FormatException {
      return HTTPResponse(
        isSuccessful: false,
        data: null,
        message: invalidResponse,
      );
    } catch (e) {
      return HTTPResponse(
        isSuccessful: false,
        data: null,
        message: somethingWrong,
      );
    }
  }

  static Future<HTTPResponse> post(
    http.Client client,
    String url,
    Map<String, dynamic> parameter,
    Map<String, dynamic> body,
  ) async {
    Uri uri = Uri.parse(url);
    parameter["api_key"] = ApiUrl.kApiKey;

    final Uri newUri = uri.replace(queryParameters: parameter);
    var headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await client.post(newUri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return HTTPResponse(
          data: body,
          isSuccessful: true,
          responseCode: response.statusCode,
          message: null,
        );
      } else {
        return HTTPResponse(
          isSuccessful: false,
          data: null,
          message: response.body,
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      return HTTPResponse(
        isSuccessful: false,
        data: null,
        message: unableToReach,
      );
    } on FormatException {
      return HTTPResponse(
        isSuccessful: false,
        data: null,
        message: invalidResponse,
      );
    } catch (e) {
      return HTTPResponse(
        isSuccessful: false,
        data: null,
        message: somethingWrong,
      );
    }
  }
}
