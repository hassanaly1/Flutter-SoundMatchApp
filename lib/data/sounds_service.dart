import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';

class SoundServices {
  //ListOfAllSoundPacks
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

  // Method to fetch sounds of a particular sound pack by sound pack ID
  Future<List<SoundModel>> fetchSoundsByPackId(String soundPackId) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listofsoundsByIdUrl}?id=$soundPackId');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    debugPrint('StatusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Ensure the JSON structure matches what is expected
      if (responseBody.containsKey('data')) {
        final data = responseBody['data'];

        // Check if 'sounds' key exists in the 'data' object
        if (data.containsKey('sounds')) {
          final List<dynamic> soundsData = data['sounds'];

          // Convert each sound data to SoundModel
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
}
