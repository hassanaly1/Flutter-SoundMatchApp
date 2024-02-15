import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';

class ResultController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool shouldShowConfetti = false.obs;
  late ConfettiController confettiController;

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController();
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    currentIndex.value = index;
    shouldShowConfetti.value = index == 0;
    print(index);
  }

  void stopConfetti() {
    shouldShowConfetti.value = false;
  }

  void playConfetti() {
    confettiController.play();
  }

  @override
  void onClose() {
    confettiController.dispose(); // Dispose of the ConfettiController
    super.onClose();
  }
}
