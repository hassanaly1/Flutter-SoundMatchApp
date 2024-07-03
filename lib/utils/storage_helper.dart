import 'package:get_storage/get_storage.dart';

class MyAppStorage {
  static final storage = GetStorage();

  static final token = storage.read('token');
  static final userId = storage.read('user_info')['_id'];
  static final userEmail = storage.read('user_info')['email'];
  static final firstName = storage.read('user_info')['first_name'];
  static final lastName = storage.read('user_info')['last_name'];
  static final fullName = storage.read('user_info')['first_name'] +
      " " +
      storage.read('user_info')['last_name'];
}
