import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/repositories/user_repository.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/user_model.dart';
import 'package:sound_app/services/authentication_repository.dart';

class SignupController extends GetxController {
  RxBool isGuestUser = false.obs;
  RxBool showPassword = false.obs;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signUp() async {
    try {
      //Loading
      //CheckInternetConnection
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) return;

      //FormValidation
      if (!signupFormKey.currentState!.validate()) return;

      //Register user in Firebase Authentication
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim());

      //Save user data in Firebase FireStore
      final newUser = UserModel(
          id: userCredential.user!.uid,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          profilePicture: '');

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);
    } catch (e) {
      MySnackBarsHelper.showError(
          'Oh Snap!', e.toString(), CupertinoIcons.exclamationmark_triangle);
    }
  }
}
