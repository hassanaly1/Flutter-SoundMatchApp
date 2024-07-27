import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';

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
  Future<bool> sendOtp({required String email}) async {
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
        return true;
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: $errorResponse');

        return false;
      }
    } catch (e) {
      return false;
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

  // ChangePasswordInApp
  Future<Map<String, dynamic>> changePasswordInApp(
      {required String currentPassword,
      required String newPassword,
      required String confirmNewPassword}) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.changePasswordInAppUrl);

    final Map<String, dynamic> payload = {
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_new_password': confirmNewPassword,
    };

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${MyAppStorage.token}',
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
  } // ChangePassword

  Future<Map<String, dynamic>> changePassword({
    required String password,
    required String confirmPassword,
  }) async {
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
          'Authorization': 'Bearer ${MyAppStorage.token}',
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

  Future<bool> logout(String userId) async {
    final Uri apiUrl = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.logoutUrl);
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['status'] == 'success';
    } else {
      return false;
    }
  }

  Future<bool> updateProfileInfo(
      {required String firstName,
      required String lastName,
      required String token}) async {
    final Uri apiUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.updateProfileUrl);
    final Map<String, dynamic> payload = {
      'first_name': firstName,
      'last_name': lastName,
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
      debugPrint('StatusCode: ${response.statusCode}');
      debugPrint('ResponseBody: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> userData = jsonResponse['data'];
        MyAppStorage.storage.write('user_info', userData);
        Get.find<MyUniversalController>().updateUserInfo(userData);
        return true;
      } else {
        debugPrint('StatusCodeIfError: ${response.statusCode}');
        debugPrint('StatusCodeIfError: ${response.body}');

        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<UpdateUserImageResult> updateUserImage({
    required Uint8List userImageInBytes,
  }) async {
    debugPrint('userImageInBytes: $userImageInBytes');
    bool isSuccess = false;
    String? profileUrl;

    var headers = {
      'Authorization': 'Bearer ${MyAppStorage.token}',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.updateProfilePictureUrl}?user_id=${MyAppStorage.userId}',
      ),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'user_profiles',
        userImageInBytes,
        filename: 'user_profiles',
      ),
    );
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        debugPrint('Response: $responseString');
        try {
          Map<String, dynamic> jsonResponse = json.decode(responseString);
          if (jsonResponse['status'] == 'success') {
            profileUrl = jsonResponse['profile_url'];
            debugPrint('Profile updated successfully');
            isSuccess = true;
          } else {
            debugPrint(
                'Error: ${jsonResponse['message']} ${response.reasonPhrase}');
          }
        } on FormatException catch (e) {
          debugPrint('Error parsing response: $e');
        }
      } else {
        debugPrint(
            'Error: Status code ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: $e');
      } else {
        debugPrint('Error updating info: $e');
      }
    }

    return UpdateUserImageResult(isSuccess: isSuccess, profileUrl: profileUrl);
  }
}

class UpdateUserImageResult {
  final bool isSuccess;
  final String? profileUrl;

  UpdateUserImageResult({required this.isSuccess, this.profileUrl});
}
