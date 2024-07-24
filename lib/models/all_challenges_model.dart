// To parse this JSON data, do
//
//     final allChallengesModel = allChallengesModelFromJson(jsonString);

import 'package:sound_app/models/participant_model.dart';

class AllChallengesModel {
  String? id;
  String? name;
  bool? hasFinished;
  int? numberOfChallenges;
  String? user;
  String? sound;
  String? createdBy;
  bool? isStarted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Winner? winner;
  int? totalparticipants;

  AllChallengesModel({
    this.id,
    this.name,
    this.hasFinished,
    this.numberOfChallenges,
    this.user,
    this.sound,
    this.createdBy,
    this.isStarted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.winner,
    this.totalparticipants,
  });

  factory AllChallengesModel.fromJson(Map<String, dynamic> json) {
    print('JsonResponse: $json');
    return AllChallengesModel(
      id: json["_id"],
      name: json["name"],
      hasFinished: json["has_finished"],
      numberOfChallenges: json["number_of_challenges"],
      user: json["user"],
      sound: json["sound"],
      createdBy: json["created_by"],
      isStarted: json["is_started"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      v: json["__v"],
      winner: json["winner"] == null ? null : Winner.fromJson(json["winner"]),
      totalparticipants: json["totalparticipants"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "has_finished": hasFinished,
        "number_of_challenges": numberOfChallenges,
        "user": user,
        "sound": sound,
        "created_by": createdBy,
        "is_started": isStarted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
        "winner": winner?.toJson(),
        "totalparticipants": totalparticipants,
      };
}

class Winner {
  String? id;
  Participant? participant;
  bool? isQualified;
  String? challengeRoom;
  String? challengeGroup;
  int? achievedPercentage;
  int? passingCriteria;
  int? roomNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Winner({
    this.id,
    this.participant,
    this.isQualified,
    this.challengeRoom,
    this.challengeGroup,
    this.achievedPercentage,
    this.passingCriteria,
    this.roomNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Winner.fromJson(Map<String, dynamic> json) => Winner(
        id: json["_id"],
        participant:
            json["user"] == null ? null : Participant.fromJson(json["user"]),
        isQualified: json["is_qualified"],
        challengeRoom: json["challenge_room"],
        challengeGroup: json["challenge_group"],
        achievedPercentage: json["achieved_percentage"],
        passingCriteria: json["passing_criteria"],
        roomNumber: json["room_number"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": participant?.toJson(),
        "is_qualified": isQualified,
        "challenge_room": challengeRoom,
        "challenge_group": challengeGroup,
        "achieved_percentage": achievedPercentage,
        "passing_criteria": passingCriteria,
        "room_number": roomNumber,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
