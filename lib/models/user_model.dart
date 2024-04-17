class UserModel {
  final String id;

  final String email;
  final String profilePicture;
  String name;

  // Constructor for UserModel.
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': name,
      'Email': email,
      'ProfilePicture': profilePicture,
    };
  }
  //
  // // Factory method to create a UserModel from a Firebase document snapshot.
  // factory UserModel.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document) {
  //   if (document.data() != null) {
  //     final data = document.data()!;
  //     return UserModel(
  //       id: document.id,
  //       name: data['name'] ?? '',
  //       email: data['Email'] ?? '',
  //       profilePicture: data['ProfilePicture'] ?? '',
  //     );
  //   } else {
  //     throw Exception('Document data is null');
  //   }
  // }
}
