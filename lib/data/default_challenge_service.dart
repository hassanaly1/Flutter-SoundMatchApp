import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';

class DefaultChallengeService {
  Future<bool> uploadUserRecording({
    required Uint8List userRecordingInBytes,
    required String soundId,
    required int userId,
  }) async {
    var headers = {'Content-Type': 'multipart/form-data'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.defaultMatchUrl}?sound_id=$soundId&user_id=$userId'),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'users_sounds',
        userRecordingInBytes,
        filename: 'user_sound.mp3',
      ),
    );

    request.headers.addAll(headers);
    debugPrint('TestingDefaultSoundForUser: $userId And SoundId: $soundId');
    try {
      http.StreamedResponse response = await request.send();

      debugPrint('StatusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint('Response: $responseBody');
        return true;
      } else {
        String responseBody = await response.stream.bytesToString();
        MySnackBarsHelper.showError(
            'Error in Uploading Sound', ' please try again', Icons.error);
        debugPrint(
            'Error in Uploading Sound: ${response.statusCode} ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      MySnackBarsHelper.showError('Please try again.',
          'Something went wrong during Uploading Sound', Icons.error);

      debugPrint('Exception: $e');
      return false;
    }
  }

  Future<List<SoundModel>> fetchSounds() async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.getSoundsForDefaultMatch}');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => SoundModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Sounds for Default Match');
    }
  }
}
