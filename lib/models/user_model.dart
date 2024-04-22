class User {
  String id;
  String firstName;
  String lastName;
  String email;
  bool isEmailVerified;
  String password;
  bool isAdmin;
  DateTime createdAt;
  DateTime updatedAt;
  ResetOTP resetOTP;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    required this.password,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.resetOTP,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      isEmailVerified: json['is_email_verified'],
      password: json['password'],
      isAdmin: json['is_admin'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      resetOTP: ResetOTP.fromJson(json['resetOTP']),
    );
  }
}

class ResetOTP {
  String otp;
  DateTime expiresAt;

  ResetOTP({
    required this.otp,
    required this.expiresAt,
  });

  factory ResetOTP.fromJson(Map<String, dynamic> json) {
    return ResetOTP(
      otp: json['otp'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
