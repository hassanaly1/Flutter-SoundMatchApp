import 'dart:convert';

import 'package:sound_app/models/participant_model.dart';

ResultModel resultModelFromJson(String str) =>
    ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  List<Participant>? nextRoomUsers;
  List<UserResult>? usersResult;

  ResultModel({
    this.nextRoomUsers,
    this.usersResult,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
        nextRoomUsers: json["next_room_users"] == null
            ? []
            : List<Participant>.from(
                json["next_room_users"]!.map((x) => Participant.fromJson(x))),
        usersResult: json["users_result"] == null
            ? []
            : List<UserResult>.from(
                json["users_result"]!.map((x) => UserResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "next_room_users": nextRoomUsers == null
            ? []
            : List<dynamic>.from(nextRoomUsers!.map((x) => x.toJson())),
        "users_result": usersResult == null
            ? []
            : List<dynamic>.from(usersResult!.map((x) => x.toJson())),
      };
}

class UserResult {
  String? id;
  Participant? participant;
  bool? isQualified;
  int? achievedPercentage;
  int? passingCriteria;
  int? roomNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  UserResult({
    this.id,
    this.participant,
    this.isQualified,
    this.achievedPercentage,
    this.passingCriteria,
    this.roomNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) => UserResult(
        id: json["_id"],
        participant:
            json["user"] == null ? null : Participant.fromJson(json["user"]),
        isQualified: json["is_qualified"],
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
        "achieved_percentage": achievedPercentage,
        "passing_criteria": passingCriteria,
        "room_number": roomNumber,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
