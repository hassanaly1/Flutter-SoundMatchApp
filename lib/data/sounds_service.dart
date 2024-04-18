import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<List<dynamic>> fetchSoundById(int id) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.listofsoundsByIdUrl}?id=$id');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> sounds = responseBody['data'];
      return sounds;
    } else {
      throw Exception(
          'Failed to fetch sounds. Status code: ${response.statusCode}');
    }
  }
}
