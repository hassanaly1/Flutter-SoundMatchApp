import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/utils/toast.dart';

class DefaultChallengeService {
  Future<void> uploadUserRecording({
    required Uint8List userRecordingInBytes,
    required String soundId,
  }) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.defaultMatchUrl}'),
    );
    request.fields.addAll({
      'sound_id': '123456',
      'user_id': '${storage.read('user_info')['_id']}',
    });
    request.files.add(
      http.MultipartFile.fromBytes(
        'users_sounds',
        userRecordingInBytes,
      ),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      debugPrint(
          'Response: ${response.stream.bytesToString()} ${response.statusCode} ${response.reasonPhrase}');
      if (response.statusCode == 201) {
        debugPrint(await response.stream.bytesToString());
      } else {
        ToastMessage.showToastMessage(
            message: 'Error in Uploading Sound.', backgroundColor: Colors.red);
        debugPrint('Error in Uploading Sound');
      }
    } catch (e) {
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);

      debugPrint('Exception: $e');
    }
  }
}
