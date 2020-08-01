import 'package:http/http.dart' as http;
import 'package:unsplash/models/photo.dart';
import 'dart:convert';

class APIRepository {
  static const API_URL = 'https://api.unsplash.com';
  static const SUCCESS_CODE = 200;
  static const CREATED_CODE = 201;
  static const PER_PAGE = 20;
  static const AUTH_TOKEN = "_FTWve2Hgz0wM76SBMuGiTEF80BsQRUsVEDzxX3vgzo";

  ///Fetching latest photos (showing on home screen)
  Future<List<Photo>> fetchPhotos(int page) async {
    final response = await http.get(
        "$API_URL/photos?page=$page&per_page=$PER_PAGE",
        headers: {"Authorization": "Bearer $AUTH_TOKEN"});

    print("Request to: $API_URL/photos?page=$page&per_page=$PER_PAGE");

    if (response.statusCode != SUCCESS_CODE) {
      print(
          "API request failed with code: ${response.statusCode} on $API_URL/photos?page=$page&per_page=$PER_PAGE");
      throw Exception("API request failed with code: ${response.statusCode}");
    }

    dynamic decodedData = jsonDecode(response.body);

    return handleJsonList(decodedData);
  }

  ///Fetching single photo
  Future<Photo> fetchPhoto(String id) async {
    final response = await http.get("$API_URL/photos/$id",
        headers: {"Authorization": "Bearer $AUTH_TOKEN"});

    if (response.statusCode != SUCCESS_CODE) {
      throw Exception("API request failed with code: ${response.statusCode}");
    }

    dynamic decodedData = jsonDecode(response.body);

    return Photo().fromJson(decodedData);
  }

  Future<List<Photo>> searchByKeywords(String query, int page) async {
    final response = await http.get(
        "$API_URL/search/photos?query=$query&page=$page&per_page$PER_PAGE",
        headers: {"Authorization": "Bearer $AUTH_TOKEN"});

    if (response.statusCode != SUCCESS_CODE) {
      throw Exception("API request failed with code: ${response.statusCode}");
    }

    dynamic json = jsonDecode(response.body);

    return handleJsonList(json['results']);
  }

  Future<dynamic> likePhoto(String id) async {
    final response = await http.post("$API_URL/photos/$id/like",
        headers: {"Authorization": "Bearer $AUTH_TOKEN"});

    if (response.statusCode != CREATED_CODE) {
      throw Exception("API request failed with code: ${response.statusCode}");
    }

    dynamic json = jsonDecode(response.body);

    return json;
  }

  Future<dynamic> unlikePhoto(String id) async {
    final response = await http.delete("$API_URL/photos/$id/like",
        headers: {"Authorization": "Bearer $AUTH_TOKEN"});

    if (response.statusCode != SUCCESS_CODE) {
      throw Exception("API request failed with code: ${response.statusCode}");
    }

    dynamic json = jsonDecode(response.body);

    return json;
  }

  /// Using to make list of photos from list of json objects
  List<Photo> handleJsonList(dynamic json) {
    List<Photo> photos = [];

    json.forEach((item) {
      photos.add(Photo().fromJson(item));
    });

    return photos;
  }
}
