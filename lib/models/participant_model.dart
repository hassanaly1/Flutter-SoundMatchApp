// To parse this JSON data, do
//
//     final participant = participantFromJson(jsonString);

import 'dart:convert';

Participant participantFromJson(String str) =>
    Participant.fromJson(json.decode(str));

String participantToJson(Participant data) => json.encode(data.toJson());

class Participant {
  String id;
  String firstName;
  String lastName;
  String email;
  bool isEmailVerified;
  bool isAdmin;
  bool isOnline;
  String profile;

  Participant({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    required this.isAdmin,
    required this.isOnline,
    required this.profile,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["_id"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        email: json["email"] ?? "",
        isEmailVerified: json["is_email_verified"] ?? false,
        isAdmin: json["is_admin"] ?? false,
        isOnline: json["is_online"] ?? false,
        profile: json["profile"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_email_verified": isEmailVerified,
        "is_admin": isAdmin,
        "is_online": isOnline,
        "profile": profile,
      };
}

// List<Participant> participants = [
//   Participant(
//       name: 'John Doe',
//       imageUrl:
//           'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Jane Smith',
//       imageUrl:
//           'https://img.freepik.com/free-photo/close-up-portrait-curly-handsome-european-male_176532-8133.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Smith Mark',
//       imageUrl:
//           'https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Emily Davis',
//       imageUrl:
//           'https://img.freepik.com/free-photo/portrait-smiling-blonde-woman_23-2148316635.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Robert White',
//       imageUrl:
//           'https://img.freepik.com/free-photo/photo-handsome-unshaven-guy-looks-with-pleasant-expression-directly-camera_176532-8164.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Amanda Brown',
//       imageUrl:
//           'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Christopher',
//       imageUrl:
//           'https://img.freepik.com/free-photo/handsome-man-with-glasses_144627-18665.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Sarah Miller',
//       imageUrl:
//           'https://img.freepik.com/free-photo/horizontal-portrait-smiling-happy-young-pleasant-looking-female-wears-denim-shirt-stylish-glasses-with-straight-blonde-hair-expresses-positiveness-poses_176420-13176.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Daniel Wilson',
//       imageUrl:
//           'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'John Doe',
//       imageUrl:
//           'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Jane Smith',
//       imageUrl:
//           'https://img.freepik.com/free-photo/close-up-portrait-curly-handsome-european-male_176532-8133.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Smith Mark',
//       imageUrl:
//           'https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Emily Davis',
//       imageUrl:
//           'https://img.freepik.com/free-photo/portrait-smiling-blonde-woman_23-2148316635.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Robert White',
//       imageUrl:
//           'https://img.freepik.com/free-photo/photo-handsome-unshaven-guy-looks-with-pleasant-expression-directly-camera_176532-8164.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Amanda Brown',
//       imageUrl:
//           'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Christopher',
//       imageUrl:
//           'https://img.freepik.com/free-photo/handsome-man-with-glasses_144627-18665.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Sarah Miller',
//       imageUrl:
//           'https://img.freepik.com/free-photo/horizontal-portrait-smiling-happy-young-pleasant-looking-female-wears-denim-shirt-stylish-glasses-with-straight-blonde-hair-expresses-positiveness-poses_176420-13176.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais'),
//   Participant(
//       name: 'Daniel Wilson',
//       imageUrl:
//           'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=ais'),
// ];
