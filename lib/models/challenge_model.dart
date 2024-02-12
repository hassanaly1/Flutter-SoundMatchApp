import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/models/songs_model.dart';

class ChallengeModel {
  String? challengeName;
  SongsModel? song;
  int? id;
  int? roundsCount;
  List<Member>? participants;
  List<Member>? leftProfiles;
  List<Member>? rightProfiles;
  List<Member>? bottomProfiles;


  ChallengeModel({
    this.id,
    this.challengeName,
    this.participants,
    this.song,
    this.leftProfiles,
    this.rightProfiles,
    this.bottomProfiles,
    this.roundsCount,
  });




}
