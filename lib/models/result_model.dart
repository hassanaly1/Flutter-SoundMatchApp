import 'dart:convert';

import 'package:sound_app/models/participant_model.dart';

ResultModel resultModelFromJson(String str) =>
    ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  List<CalculateAverageResult>? calculateAverageResult;
  List<Participant>? nextRoomUsers;
  List<UsersResult>? usersResult;
  String? nextRoom;

  ResultModel({
    this.calculateAverageResult,
    this.nextRoomUsers,
    this.usersResult,
    this.nextRoom,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      calculateAverageResult: json["calculateAverageResult"] == null
          ? []
          : List<CalculateAverageResult>.from(json["calculateAverageResult"]!
              .map((x) => CalculateAverageResult.fromJson(x))),
      nextRoomUsers: json["next_room_users"] == null
          ? []
          : List<Participant>.from(
              json["next_room_users"]!.map((x) => Participant.fromJson(x))),
      usersResult: json["users_result"] == null
          ? []
          : List<UsersResult>.from(
              json["users_result"]!.map((x) => UsersResult.fromJson(x))),
      nextRoom: json["next_room"],
    );
  }

  Map<String, dynamic> toJson() => {
        "calculateAverageResult": calculateAverageResult == null
            ? []
            : List<dynamic>.from(
                calculateAverageResult!.map((x) => x.toJson())),
        "next_room_users": nextRoomUsers == null
            ? []
            : List<dynamic>.from(nextRoomUsers!.map((x) => x.toJson())),
        "users_result": usersResult == null
            ? []
            : List<dynamic>.from(usersResult!.map((x) => x.toJson())),
        "next_room": nextRoom,
      };
}

class CalculateAverageResult {
  String? id;
  int? averageAchievedPercentage;
  Participant? participant;

  CalculateAverageResult({
    this.id,
    this.averageAchievedPercentage,
    this.participant,
  });

  factory CalculateAverageResult.fromJson(Map<String, dynamic> json) =>
      CalculateAverageResult(
        id: json["_id"],
        averageAchievedPercentage: json["averageAchievedPercentage"],
        participant:
            json["user"] == null ? null : Participant.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "averageAchievedPercentage": averageAchievedPercentage,
        "user": participant?.toJson(),
      };
}

class UsersResult {
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

  UsersResult({
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

  factory UsersResult.fromJson(Map<String, dynamic> json) => UsersResult(
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
