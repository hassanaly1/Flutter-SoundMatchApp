import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/toast.dart';

class DefaultChallengeService {
  Future<void> uploadUserRecording({
    required Uint8List userRecordingInBytes,
    required String soundId,
    required String userId,
  }) async {
    var headers = {
      'Content-Type': 'multipart/form-data', // Added header
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.defaultMatchUrl}?sound_id=$soundId&user_id=123'),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'users_sounds',
        userRecordingInBytes,
        filename: 'user_sound.mp3', // Added filename
      ),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint('Response: $responseBody');
      } else {
        String responseBody =
            await response.stream.bytesToString(); // Properly await response
        ToastMessage.showToastMessage(
            message: 'Error in Uploading Sound: $responseBody',
            backgroundColor: Colors.red);
        debugPrint(
            'Error in Uploading Sound: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);

      debugPrint('Exception: $e');
    }
  }
}
