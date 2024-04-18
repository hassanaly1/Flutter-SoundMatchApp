import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/utils/api_endpoints.dart';

class AuthService {
  // RegisterUser
  Future<Map<String, dynamic>> registerUser(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String confirmPassword}) async {
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
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': errorResponse['message'],
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

  // VerifyEmail
  Future<Map<String, dynamic>> verifyEmail(
      {required String email, required String otp}) async {
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
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': errorResponse['message'],
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

  //LoginUser
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
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': errorResponse['message'],
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

  //ForgetPassword || SendOtp
  Future<Map<String, dynamic>> sendOtp({required String email}) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.sendOtpUrl);

    final Map<String, dynamic> payload = {
      "email": email,
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
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': errorResponse['message'],
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

  // VerifyOtpUrl
  Future<Map<String, dynamic>> verifyOtp(
      {required String email, required String otp}) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.verifyOtpUrl);

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
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': errorResponse['message'],
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

  // ChangePassword
  Future<Map<String, dynamic>> changePassword(
      {required String password,
      required String confirmPassword,
      required String token}) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.changePasswordUrl);

    final Map<String, dynamic> payload = {
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint('StatusCode: ${response.statusCode}');
        debugPrint('ResponseBody: ${response.body}');

        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return {
          'status': 'error',
          'message': errorResponse['message'],
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
