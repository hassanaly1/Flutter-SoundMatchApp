import 'package:get/get.dart';
import 'package:sound_app/utils/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
