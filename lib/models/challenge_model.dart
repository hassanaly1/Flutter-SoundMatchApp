import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';

class ChallengeModel {
  String? challengeName;
  SoundModel? song;
  int? id;
  int? numberOfRounds;
  List<Participant>? participants;

  // List<Participant>? leftProfiles;
  // List<Participant>? rightProfiles;
  // List<Participant>? bottomProfiles;

  ChallengeModel({
    this.id,
    this.challengeName,
    this.participants,
    this.song,
    // this.leftProfiles,
    // this.rightProfiles,
    // this.bottomProfiles,
    this.numberOfRounds,
  });
}
