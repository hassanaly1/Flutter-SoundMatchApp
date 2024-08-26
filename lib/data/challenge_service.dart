import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/all_challenges_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';

class ChallengeService {
  Future<bool> uploadUserSound({
    required Uint8List? userRecordingInBytes,
    required String userId,
    required String roomId,
  }) async {
    debugPrint('Uploading Sound for User $userId in Room $roomId');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.uploadSounds}'),
    );

    // Add the file
    if (userRecordingInBytes != null) {
      print('User Recording Found');
      print('userRecordingInBytes length: ${userRecordingInBytes.length}');
      request.files.add(
        http.MultipartFile.fromBytes(
          'users_sounds',
          userRecordingInBytes,
          filename: 'users_sounds.mp3',
          // contentType: MediaType('audio', 'aac'),
        ),
      );
    } else {
      print('User Recording Not Found');
    }

    // Add the user info as fields
    request.fields['parsedUser'] = jsonEncode({
      'user_id': userId,
      'room_id': roomId,
      'has_sound': userRecordingInBytes != null ? 'YES' : 'NO',
    });
    // print(jsonEncode({
    //   'user_id': userId,
    //   'room_id': roomId,
    //   'has_sound': userRecordingInBytes != null ? 'YES' : 'NO',
    // }));
    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      debugPrint('StatusCode: ${response.statusCode}\n'
          'ReasonPhrase: ${response.reasonPhrase}\n'
          'Message: ${jsonResponse['message']}\n'
          // 'Response: $jsonResponse',
          );

      if (response.statusCode == 200) {
        return true;
      } else {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Uploading Sound.', Icons.error);
        debugPrint(
          'Error in Uploading Sound: ${response.statusCode} ${response.reasonPhrase}',
        );
        return false;
      }
    } catch (e) {
      MySnackBarsHelper.showError('Please try again.',
          'Something went wrong during Uploading Sound.', Icons.error);
      debugPrint('Exception: $e');
      return false;
    }
  }

  Future<List<AllChallengesModel>?> fetchAllChallenges() async {
    var response = await http.post(
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.getUserResults}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${MyAppStorage.storage.read('token')}',
      },
    );

    debugPrint('Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> challengesJson = jsonResponse['challenge_list'];
      List<AllChallengesModel> challenges = challengesJson
          .map((json) => AllChallengesModel.fromJson(json))
          .toList();
      return challenges;
    } else {
      debugPrint('Failed to load challenges: ${response.statusCode}');
      return null;
    }
  }
}
