import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

// Future<bool> uploadUserSound({
//   required Uint8List? userRecordingInBytes,
//   required String userId,
//   required String roomId,
// }) async {
//   debugPrint('Uploading Sound for User $userId in Room $roomId');
//   var headers = {
//     'Content-Type': 'multipart/form-data',
//   };
//
//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.uploadSounds}'),
//   );
//
//   // Add the file
//   if (userRecordingInBytes != null) {
//     print('User Recording Found');
//     print('userRecordingInBytes: $userRecordingInBytes');
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'users_sounds',
//         userRecordingInBytes,
//         filename: 'users_sounds',
//         // contentType: MediaType(
//         //   'audio',
//         //   'aac',
//         // ),
//       ),
//     );
//   } else {
//     // request.fields['users_sounds'] = 'null';
//     print('User Recording Not Found');
//   }
//
//   // print(jsonEncode({
//   //   'user_id': userId,
//   //   'room_id': roomId,
//   // }));
//
//   // Add the user info as fields
//   request.fields['parsedUser'] = jsonEncode({
//     'user_id': userId,
//     'room_id': roomId,
//   });
//
//   request.headers.addAll(headers);
//
//   try {
//     http.StreamedResponse response = await request.send();
//     String responseBody = await response.stream.bytesToString();
//     Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
//
//     debugPrint(
//       'StatusCode: ${response.statusCode}'
//       'ReasonPhrase: ${response.reasonPhrase}'
//       'Message: ${jsonResponse['message']}'
//       'Response: $jsonResponse',
//     );
//
//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       ToastMessage.showToastMessage(
//         message: 'Issue in Uploading Sound: ${response.reasonPhrase} ',
//         backgroundColor: Colors.red,
//       );
//       debugPrint(
//         'Error in Uploading Sound: ${response.statusCode} ${response.reasonPhrase}',
//       );
//       return false;
//     }
//   } catch (e) {
//     ToastMessage.showToastMessage(
//       message: 'Something went wrong, please try again',
//       backgroundColor: Colors.red,
//     );
//     debugPrint('Exception: $e');
//     return false;
//   }
// }
}
