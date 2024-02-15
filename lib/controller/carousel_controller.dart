import 'package:get/get.dart';

class CarouselSliderController extends GetxController {
  var currentIndex = 0.obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
