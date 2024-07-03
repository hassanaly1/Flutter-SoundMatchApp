class ChallengeModel {
  Challenge challenge;
  List<PassingCriteria> passingCriteria;
  ChallengeRoom challengeRoom;
  Invitation invitation;

  ChallengeModel({
    required this.challenge,
    required this.passingCriteria,
    required this.challengeRoom,
    required this.invitation,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => ChallengeModel(
        challenge: Challenge.fromJson(json["challenge"]),
        passingCriteria: List<PassingCriteria>.from(
            json["passing_criteria"].map((x) => PassingCriteria.fromJson(x))),
        challengeRoom: ChallengeRoom.fromJson(json["challenge_room"]),
        invitation: Invitation.fromJson(json["invitation"]),
      );

  Map<String, dynamic> toJson() => {
        "challenge": challenge.toJson(),
        "passing_criteria":
            List<dynamic>.from(passingCriteria.map((x) => x.toJson())),
        "challenge_room": challengeRoom.toJson(),
        "invitation": invitation.toJson(),
      };
}

class Challenge {
  String name;
  String numberOfChallenges;
  String user;
  String sound;
  String createdBy;

  Challenge({
    required this.name,
    required this.numberOfChallenges,
    required this.user,
    required this.sound,
    required this.createdBy,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        name: json["name"],
        numberOfChallenges: json["number_of_challenges"],
        user: json["user"],
        sound: json["sound"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number_of_challenges": numberOfChallenges,
        "user": user,
        "sound": sound,
        "created_by": createdBy,
      };
}

class ChallengeRoom {
  List<String> users;
  int totalMembers;
  String currentTurnHolder;

  ChallengeRoom({
    required this.users,
    required this.totalMembers,
    required this.currentTurnHolder,
  });

  factory ChallengeRoom.fromJson(Map<String, dynamic> json) => ChallengeRoom(
        users: List<String>.from(json["users"].map((x) => x)),
        totalMembers: json["total_members"],
        currentTurnHolder: json["current_turn_holder"],
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x)),
        "total_members": totalMembers,
        "current_turn_holder": currentTurnHolder,
      };
}

class Invitation {
  String type;
  List<String> recipients;
  String createdBy;

  Invitation({
    required this.type,
    required this.recipients,
    required this.createdBy,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        type: json["type"],
        recipients: List<String>.from(json["recipients"].map((x) => x)),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "recipients": List<dynamic>.from(recipients.map((x) => x)),
        "created_by": createdBy,
      };
}

class PassingCriteria {
  int percentage;
  int room;

  PassingCriteria({
    required this.percentage,
    required this.room,
  });

  factory PassingCriteria.fromJson(Map<String, dynamic> json) =>
      PassingCriteria(
        percentage: json["percentage"],
        room: json["room"],
      );

  Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "room": room,
      };
}

// // Function to send data via socket
// void sendChallengeData(IO.Socket socket, ChallengeModel challengeModel) {
//   try {
//     final data = challengeModel.toJson();
//     socket.emit('your_event_name', data);
//   } catch (e) {
//     print('Error sending challenge data: $e');
//   }
// }
//
// // Example usage
// void main() {
//   IO.Socket socket = IO.io('http://your.socket.server', <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': true,
//   });
//
//   socket.onConnect((_) {
//     print('Connected to Socket Server');
//
//     // Create an instance of ChallengeModel
//     ChallengeModel challengeModel = ChallengeModel(
//       challenge: Challenge(
//         name: 'variamna',
//         numberOfChallenges: '3',
//         user: '6610d5301605a835f150583f',
//         sound: '661d11d3c4c6b15767adf2b8',
//         createdBy: '6610d5301605a835f150583f',
//       ),
//       passingCriteria: [
//         PassingCriterion(percentage: 50, room: 1),
//         PassingCriterion(percentage: 70, room: 2),
//         PassingCriterion(percentage: 80, room: 3),
//       ],
//       challengeRoom: ChallengeRoom(
//         users: ['6610d5301605a835f150583f'],
//         totalMembers: 1,
//         currentTurnHolder: '6610d5301605a835f150583f',
//       ),
//       invitation: Invitation(
//         type: 'challenge',
//         recipients: [
//           '6610d5301605a835f150583f',
//           '661cf0ecd7ce5557dd8604c6',
//           '661cf1c678910a9510b542e7',
//         ],
//         createdBy: '6610d5301605a835f150583f',
//       ),
//     );
//
//     // Send the data
//     sendChallengeData(socket, challengeModel);
//   });
//
//   socket.onDisconnect((_) {
//     print('Disconnected from Socket Server');
//   });
// }
