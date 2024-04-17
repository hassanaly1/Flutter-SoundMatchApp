import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/utils/api_endpoints.dart';

class AuthService {
  // Method to register the user
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.registerUserUrl);
    final Map<String, dynamic> payload = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      final response = await http.post(apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload));

      if (response.statusCode == 201) {
        debugPrint('StatusCode: ${response.statusCode}');
        debugPrint('ResponseBody: ${response.body}');
        return jsonDecode(response.body);
      } else {
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');
        return {
          'status': 'error',
          'message': 'HTTP error: ${response.statusCode}',
          'code': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  // Verify email using OTP
  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.verifyEmailUrl);

    final Map<String, dynamic> payload = {
      'email': email,
      'otp': otp,
    };

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint('StatusCode: ${response.statusCode}');
        debugPrint('ResponseBody: ${response.body}');

        return jsonDecode(response.body);
      } else {
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': 'HTTP error: ${response.statusCode}',
          'code': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password}) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.loginUserUrl);

    final Map<String, dynamic> payload = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload));

      if (response.statusCode == 200) {
        debugPrint('StatusCode: ${response.statusCode}');
        debugPrint('ResponseBody: ${response.body}');
        return jsonDecode(response.body);
      } else {
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');
        return {
          'status': 'error',
          'message': 'HTTP error: ${response.statusCode}',
          'code': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error: $e',
      };
    }
  }
}
