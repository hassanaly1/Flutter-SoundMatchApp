import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/controller/carousel_controller.dart';

class MyAppStorage {
  static final storage = GetStorage();

  // Instance member for the controller
  late GuestController controller;

  // Static fields
  // static late final String? token;
  // static late final String? userId;
  // static late final String? userEmail;
  // static late final String? userProfilePicture;
  // static const dummyProfilePicture = 'assets/images/guest_user_profile.PNG';
  // static late final String? firstName;
  // static late final String? lastName;
  // static late final String? fullName;

  // Private constructor
  MyAppStorage._internal() {
    controller = Get.find<GuestController>();
  }

  // Singleton factory
  static final MyAppStorage instance = MyAppStorage._internal();

  // Static method to initialize static fields
  static void initialize() {
    final guestController = Get.find<GuestController>();
    if (!guestController.isGuestUser.value) {
      final userInfo = storage.read('user_info');
      // token = storage.read('token');
      // userId = userInfo?['_id'];
      // userEmail = userInfo?['email'];
      // userProfilePicture = userInfo?['profile'];
      // firstName = userInfo?['first_name'] ?? 'Guest';
      // lastName = userInfo?['last_name'] ?? 'User';
      // fullName =
      //     (userInfo?['first_name'] != null && userInfo?['last_name'] != null)
      //         ? '$firstName $lastName}'
      //         : null;
    } else {
      // token = null;
      // userId = null;
      // userEmail = null;
      // userProfilePicture = dummyProfilePicture;
      // firstName = 'Guest';
      // lastName = 'User';
      // fullName = 'Guest User';
    }
  }

// void removeUser() {
//   storage.remove('token');
//   storage.remove('user_info');
//   initialize(); // Re-initialize to reflect changes
// }
}
