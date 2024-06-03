import 'dart:convert';
import 'package:app/helper/constant.dart';
import 'package:http/http.dart' as http;

class API {
  Future<http.Response> postRequest({
    required String route,
    required Map<String, String> data,
    String? token,  
  }) async {
    String url = apiUrl + route;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(token),  // Utiliser la méthode _header pour inclure le token
      );
      return response;
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to post request: $e");
    }
  }

  Future<http.Response> getRequest({
    required String route,
    required String token,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.get(
        Uri.parse(url),
        headers: _header(token),
      );
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to get request: $e");
    }
  }

  Future<http.Response> putRequest({
    required String route,
    required Map<String, String> data,
    required String token,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(token),
      );
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to put request: $e");
    }
  }

  Map<String, String> _header([String? token]) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
}
