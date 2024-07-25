// To parse this JSON data, do
//
//     final challengeRoomModel = challengeRoomModelFromJson(jsonString);

import 'dart:convert';

import 'package:sound_app/models/participant_model.dart';

ChallengeRoomModel challengeRoomModelFromJson(String str) =>
    ChallengeRoomModel.fromJson(json.decode(str));

String challengeRoomModelToJson(ChallengeRoomModel data) =>
    json.encode(data.toJson());

class ChallengeRoomModel {
  String? id;
  bool? isFinished;
  bool? isExpired;
  List<Participant>? users;
  int? totalMembers;
  int? challengeRoomNumber; //
  ChallengeGroup? challengeGroup;
  List<dynamic>? userSounds;
  Sound? sound;
  Participant? currentTurnHolder;
  PassingCriteriaa? passingCriteria;
  bool? isActive;
  Participant? createdBy;
  bool? isStarted;
  List<dynamic>? uploaderUserIds;
  List<dynamic>? turnHolder;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? turnTime;
  int? v;

  ChallengeRoomModel({
    this.id,
    this.isFinished,
    this.isExpired,
    this.users,
    this.totalMembers,
    this.challengeRoomNumber,
    this.challengeGroup,
    this.userSounds,
    this.sound,
    this.currentTurnHolder,
    this.passingCriteria,
    this.isActive,
    this.createdBy,
    this.isStarted,
    this.uploaderUserIds,
    this.turnHolder,
    this.createdAt,
    this.updatedAt,
    this.turnTime,
    this.v,
  });

  factory ChallengeRoomModel.fromJson(Map<String, dynamic> json) =>
      ChallengeRoomModel(
        id: json["_id"],
        isFinished: json["is_finished"],
        isExpired: json["is_expired"],
        users: json["users"] == null
            ? []
            : List<Participant>.from(
                json["users"]!.map((x) => Participant.fromJson(x))),
        totalMembers: json["total_members"],
        challengeRoomNumber: json["challenge_room_number"],
        challengeGroup: json["challenge_group"] == null
            ? null
            : ChallengeGroup.fromJson(json["challenge_group"]),
        userSounds: json["user_sounds"] == null
            ? []
            : List<dynamic>.from(json["user_sounds"]!.map((x) => x)),
        sound: json["sound"] == null ? null : Sound.fromJson(json["sound"]),
        currentTurnHolder: json["current_turn_holder"] == null
            ? null
            : Participant.fromJson(json["current_turn_holder"]),
        passingCriteria: json["passing_criteria"] == null
            ? null
            : PassingCriteriaa.fromJson(json["passing_criteria"]),
        isActive: json["is_active"],
        createdBy: json["created_by"] == null
            ? null
            : Participant.fromJson(json["created_by"]),
        isStarted: json["is_started"],
        uploaderUserIds: json["uploader_user_ids"] == null
            ? []
            : List<dynamic>.from(json["uploader_user_ids"]!.map((x) => x)),
        turnHolder: json["turn_holder"] == null
            ? []
            : List<dynamic>.from(json["turn_holder"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        turnTime: json["turn_time"] == null
            ? null
            : DateTime.parse(json["turn_time"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "is_finished": isFinished,
        "is_expired": isExpired,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "total_members": totalMembers,
        "challenge_room_number": challengeRoomNumber,
        "challenge_group": challengeGroup?.toJson(),
        "user_sounds": userSounds == null
            ? []
            : List<dynamic>.from(userSounds!.map((x) => x)),
        "sound": sound?.toJson(),
        "current_turn_holder": currentTurnHolder?.toJson(),
        "passing_criteria": passingCriteria?.toJson(),
        "is_active": isActive,
        "created_by": createdBy?.toJson(),
        "is_started": isStarted,
        "uploader_user_ids": uploaderUserIds == null
            ? []
            : List<dynamic>.from(uploaderUserIds!.map((x) => x)),
        "turn_holder": turnHolder == null
            ? []
            : List<dynamic>.from(turnHolder!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class ChallengeGroup {
  String? id;
  String? name;
  bool? hasFinished;
  int? numberOfChallenges;
  String? user;
  String? sound;
  String? createdBy;
  bool? isStarted;
  List<PassingCriteriaa>? passingCriteria;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ChallengeGroup({
    this.id,
    this.name,
    this.hasFinished,
    this.numberOfChallenges,
    this.user,
    this.sound,
    this.createdBy,
    this.isStarted,
    this.passingCriteria,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ChallengeGroup.fromJson(Map<String, dynamic> json) => ChallengeGroup(
        id: json["_id"],
        name: json["name"],
        hasFinished: json["has_finished"],
        numberOfChallenges: json["number_of_challenges"],
        user: json["user"],
        sound: json["sound"],
        createdBy: json["created_by"],
        isStarted: json["is_started"],
        passingCriteria: json["passing_criteria"] == null
            ? []
            : List<PassingCriteriaa>.from(json["passing_criteria"]!
                .map((x) => PassingCriteriaa.fromJson(x))),
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
        "name": name,
        "has_finished": hasFinished,
        "number_of_challenges": numberOfChallenges,
        "user": user,
        "sound": sound,
        "created_by": createdBy,
        "is_started": isStarted,
        "passing_criteria": passingCriteria == null
            ? []
            : List<dynamic>.from(passingCriteria!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class PassingCriteriaa {
  String? id;
  int? percentage;
  int? room;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PassingCriteriaa({
    this.id,
    this.percentage,
    this.room,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PassingCriteriaa.fromJson(Map<String, dynamic> json) =>
      PassingCriteriaa(
        id: json["_id"],
        percentage: json["percentage"],
        room: json["room"],
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
        "percentage": percentage,
        "room": room,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Sound {
  String? id;
  String? name;
  String? url;
  int? duration;
  bool? isActive;
  int? size;
  String? packId;
  int? v;

  Sound({
    this.id,
    this.name,
    this.url,
    this.duration,
    this.isActive,
    this.size,
    this.packId,
    this.v,
  });

  factory Sound.fromJson(Map<String, dynamic> json) => Sound(
        id: json["_id"],
        name: json["name"],
        url: json["url"],
        duration: json["duration"],
        isActive: json["is_active"],
        size: json["size"],
        packId: json["pack_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "url": url,
        "duration": duration,
        "is_active": isActive,
        "size": size,
        "pack_id": packId,
        "__v": v,
      };
}
