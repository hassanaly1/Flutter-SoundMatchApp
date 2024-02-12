import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  late AudioPlayer _audioPlayer;

  AudioPlayerService() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> initAudioPlayer(String audioFilePath) async {
    try {
      await _audioPlayer.setAsset(audioFilePath);
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  void dispose() {
    _audioPlayer.dispose();
  }
}
