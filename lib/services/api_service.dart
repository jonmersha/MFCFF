import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  // --- HELPER: HEADERS ---
  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT ${token ?? ""}',
    };
  }
  // Add this to your ApiService class in lib/services/api_service.dart

  Future<http.Response> uploadImage(
    String url,
    String fieldName,
    String filePath,
  ) async {
    // 1. Create the PATCH request
    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    // 2. Fetch headers using your existing _getHeaders() helper
    // This ensures 'Authorization': 'JWT <token>' is included correctly
    final headers = await _getHeaders();
    request.headers.addAll(headers);

    // 3. Attach the file
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    // 4. Send and convert to standard Response
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Debugging: If it still returns 400, this will show the exact reason from Django
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint("UPLOAD ERROR BODY: ${response.body}");
    }

    return response;
  }

  // Login: Returns true if successful
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'jwt_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse(ApiConstants.userProfile),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Could not fetch user profile");
  }

  // lib/services/api_service.dart
  Future<bool> updateProfile(Map<String, String> data) async {
    try {
      final response = await http.patch(
        Uri.parse(ApiConstants.userProfile), // Djoser Endpoint
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      // 200 OK means update successful
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Sign Up: Creates a new user in Django
  // lib/services/api_service.dart
  Future<bool> signUp(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.signUp), // Djoser /auth/users/
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      // 201 Created is the standard Djoser response for new users
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // --- AUTH OPERATIONS ---
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Generic GET request
  Future<List<dynamic>> get(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data from $url");
    }
  }


  Future<dynamic> getUpdate(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      // This can now safely return a Map or a List
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
  // Generic POST request
  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
  }

  // Generic PUT request (For Updates)
  Future<http.Response> put(String url, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
  }

  // Generic DELETE request (For Removals)
  Future<http.Response> delete(String url) async {
    return await http.delete(Uri.parse(url), headers: await _getHeaders());
  }

  // Generic PATCH request (Optional - for partial updates)
  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    return await http.patch(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
  }
}
