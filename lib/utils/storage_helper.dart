import 'package:get_storage/get_storage.dart';

class MyAppStorage {
  static final storage = GetStorage();

  void removeUser() {
    storage.remove('token');
    storage.remove('user_info');
  }

  static final token = storage.read('token');
  static final userId = storage.read('user_info')['_id'];
  static final userEmail = storage.read('user_info')['email'];
  static final userProfilePicture = storage.read('user_info')['profile'];
  static const dummyProfilePicture =
      'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=ais';
  static final firstName = storage.read('user_info')['first_name'];
  static final lastName = storage.read('user_info')['last_name'];
  static final fullName = storage.read('user_info')['first_name'] +
      " " +
      storage.read('user_info')['last_name'];
}
