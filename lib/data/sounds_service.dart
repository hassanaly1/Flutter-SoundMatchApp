import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';

class SoundServices {
  Future<List<dynamic>> fetchSoundPacks(int page) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listofsoundpacksUrl}?page=$page&limit=10');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> soundPacks = responseBody['data'];
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
      {required String searchString}) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listOfParticipantsUrl}');
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
