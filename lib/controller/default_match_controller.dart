import 'package:get/get.dart';

class DefaultMatchController extends GetxController {
  RxBool isDefaultAudioPlaying = false.obs;
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  RxBool isUserRecordingCompleted = false.obs;
  RxBool isResultCalculating = false.obs;
  RxBool isResultCalculated = false.obs;
}
