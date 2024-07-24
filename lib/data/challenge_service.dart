import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/models/all_challenges_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/toast.dart';

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
          filename: 'users_sounds.aac',
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
        ToastMessage.showToastMessage(
          message: 'Issue in Uploading Sound: ${response.reasonPhrase} ',
          backgroundColor: Colors.red,
        );
        debugPrint(
          'Error in Uploading Sound: ${response.statusCode} ${response.reasonPhrase}',
        );
        return false;
      }
    } catch (e) {
      ToastMessage.showToastMessage(
        message: 'Something went wrong, please try again',
        backgroundColor: Colors.red,
      );
      debugPrint('Exception: $e');
      return false;
    }
  }

  Future<List<AllChallengesModel>?> fetchAllChallenges() async {
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiI2NjlhNTU5NzcxN2U0N2M0NDY2NTI1NmIiLCJpYXQiOjE3MjE2MjUwMjIsImV4cCI6MTcyMjA1NzAyMn0.ZrjTe4LV3FKgrukOkOSu7hepM_1fO8OAjn1p2cw3ZUQ';

    var response = await http.post(
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.getUserResults}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

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
