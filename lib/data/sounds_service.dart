import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';

class SoundServices {
  // Future<bool> addFreeSoundPacks({required String soundPackId}) async {
  //   final url =
  //       Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.addFreeSoundPackUrl);
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${MyAppStorage.token}',
  //     },
  //     body: jsonEncode({
  //       'sound_pack_id': soundPackId,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     debugPrint('Added Free SoundPack Successfully');
  //     debugPrint(response.body);
  //     return true;
  //   } else {
  //     throw Exception(
  //         'Failed to add free soundpacks. Status code: ${response.statusCode}');
  //   }
  // }

  Future<String> addPaidSoundPacks({required String soundPackId}) async {
    final url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.addPaidSoundPackUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${MyAppStorage.storage.read('token')}',
      },
      body: jsonEncode({
        'id': soundPackId,
      }),
    );
    print('StatusCodeForPaymentIntent: ${response.statusCode}');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Response Body: $responseBody');
      var clientSecret = responseBody['payment_indent']['client_secret'];
      // print('Client Secret: $clientSecret');
      return clientSecret;
    } else {
      throw Exception(
          'Error Getting Client Secret. Status Code: ${response.statusCode}');
    }
  }

  Future<List<SoundPackModel>> fetchSoundPacks({required int page}) async {
    debugPrint('Loading Page $page SoundPacks');
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listofsoundpacksUrl}?page=$page&limit=10');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> engineData = responseData['data'];
      List<SoundPackModel> soundPacks =
          engineData.map((data) => SoundPackModel.fromJson(data)).toList();

      return soundPacks;
    } else {
      throw Exception(
          'Failed to fetch soundpacks. Status code: ${response.statusCode}');
    }
  }

  Future<List<SoundModel>> fetchSoundsByPackId(String soundPackId) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listofsoundsByIdUrl}?id=$soundPackId');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    debugPrint('StatusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody.containsKey('data')) {
        final data = responseBody['data'];

        if (data.containsKey('sounds')) {
          final List<dynamic> soundsData = data['sounds'];

          List<SoundModel> sounds = soundsData.map((soundData) {
            return SoundModel.fromJson(soundData);
          }).toList();

          return sounds;
        } else {
          throw Exception('Missing "sounds" key in the response data');
        }
      } else {
        throw Exception('Missing "data" key in the response body');
      }
    } else {
      throw Exception(
          'Failed to fetch sounds for sound pack ID $soundPackId. Status code: ${response.statusCode}');
    }
  }

  Future<List<Participant>> fetchParticipants(
      {required String searchString, required int page}) async {
    debugPrint('Loading Page $page Participants');
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listOfParticipantsUrl}?page=$page&limit=10');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'search': searchString}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> participants = responseBody['data'];

      return participants
          .map((participant) => Participant.fromJson(participant))
          .toList();
    } else {
      throw Exception(
          'Failed to fetch participants. Status code: ${response.statusCode}');
    }
  }
}
