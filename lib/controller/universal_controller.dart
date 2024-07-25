import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sound_app/data/payment_service.dart';
import 'package:sound_app/data/sounds_service.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/utils/storage_helper.dart';

class MyUniversalController extends GetxController {
  var isSoundPacksAreLoading = false.obs;
  RxBool isGuestUser = false.obs;
  RxBool isConnectedToInternet = false.obs;
  StreamSubscription? _internetConnectionStreamSubscription;
  RxList<SoundModel> soundsById = <SoundModel>[].obs;

  RxList<SoundPackModel> allSoundPacks = <SoundPackModel>[].obs;
  RxList<SoundPackModel> userSoundPacks = <SoundPackModel>[].obs;
  ScrollController scrollController = ScrollController();
  final RxInt _currentPage = 1.obs;

  final storage = MyAppStorage.storage;
  XFile? userImage;
  RxString userImageURL = ''.obs;
  Uint8List? userImageInBytes;
  RxMap userInfo = {}.obs;

  set setUserImageUrl(String value) {
    userImageURL.value = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen(
      (event) {
        debugPrint('Internet Status: $event');
        switch (event) {
          case InternetStatus.connected:
            isConnectedToInternet.value = true;
            break;
          case InternetStatus.disconnected:
            isConnectedToInternet.value = false;
            break;
          default:
            isConnectedToInternet.value = false;
            break;
        }
      },
    );
    userInfo.value = storage.read('user_info') ?? {};
    userImageURL.value = MyAppStorage.userProfilePicture != null
        ? MyAppStorage.userProfilePicture!
        : '';
    debugPrint('UserImageAtStart: $userImageURL');

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isSoundPacksAreLoading.value) {
          _loadNextPageSoundPacks();
        }
      }
    });
  }

  void _loadNextPageSoundPacks() async {
    isSoundPacksAreLoading.value = true;

    final List<SoundPackModel> nextPageSoundPacks =
        await SoundServices().fetchSoundPacks(_currentPage.value);

    // Create a Set of existing soundpack IDs to avoid duplicates
    Set<String?> existingSoundPacksIds =
        allSoundPacks.map((soundPack) => soundPack.id).toSet();

    // Add only unique SoundPacks
    for (var soundPacks in nextPageSoundPacks) {
      if (!existingSoundPacksIds.contains(soundPacks.id)) {
        allSoundPacks.add(soundPacks);
        // Update the set with the new soundpack ID
        existingSoundPacksIds.add(soundPacks.id);
      }
    }

    // Only increment the page if we received a full page of soundpacks
    if (nextPageSoundPacks.length >= 10) {
      _currentPage.value++;
    }

    isSoundPacksAreLoading.value = false;
  }

  // Challenges
  RxList<ChallengeModel> challenges = <ChallengeModel>[
    ChallengeModel(
      challenge: Challenge(
        name: 'Free Sound Match',
        numberOfChallenges: '1',
        user: MyAppStorage.userId,
        sound: "",
        createdBy: MyAppStorage.userId,
      ),
      passingCriteria: [],
      challengeRoom: ChallengeRoom(
        users: [MyAppStorage.userId],
        totalMembers: 1,
        currentTurnHolder: MyAppStorage.userId,
      ),
      invitation: Invitation(
        type: 'challenge',
        recipients: [
          MyAppStorage.userId,
        ],
        createdBy: MyAppStorage.userId,
      ),
    )
  ].obs;

  // Future<void> addFreeSoundPack(SoundPackModel soundPackModel) async {
  //   try {
  //     bool isSuccess = await SoundServices()
  //         .addFreeSoundPacks(soundPackId: soundPackModel.id);
  //     if (isSuccess) {
  //       ToastMessage.showToastMessage(
  //           message: 'Sound Pack Added Successfully',
  //           backgroundColor: Colors.green);
  //     }
  //   } catch (e) {
  //     debugPrint('Error Adding FreeSoundPack: $e');
  //   }
  // }

  Future<void> addPaidSoundPack(SoundPackModel soundPackModel) async {
    try {
      String clientSecret = await SoundServices()
          .addPaidSoundPacks(soundPackId: soundPackModel.id);

      if (clientSecret.isNotEmpty) {
        debugPrint('Payment Intent Client Secret: $clientSecret');

        // Initialize and present the payment sheet
        await StripeService.instance.makePayment(
          paymentIntentClientSecret: clientSecret,
        );
      }
    } catch (e) {
      debugPrint('Error Getting Client Secret for PaidSoundPack: $e');
    }
  }

  Future<void> fetchSoundPacks(int page) async {
    try {
      allSoundPacks.clear();
      _currentPage.value = 1;
      final List<SoundPackModel> nextPageSoundPacks =
          await SoundServices().fetchSoundPacks(_currentPage.value);
      allSoundPacks.value = nextPageSoundPacks;
    } catch (e) {
      debugPrint('Error Fetching SoundPacks: $e');
    }
  }

  Future<void> fetchSoundsByPackId(String soundPackId) async {
    soundsById.clear();
    try {
      List<SoundModel> fetchedSounds =
          await SoundServices().fetchSoundsByPackId(soundPackId);
      soundsById.addAll(fetchedSounds);
      debugPrint(
          'Fetched Sounds for SoundPack ID $soundPackId: ${soundsById.length}');
    } catch (e) {
      debugPrint('Error Fetching Sounds for SoundPack ID $soundPackId: $e');
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  updateUserInfo(Map<String, dynamic> userInfo) {
    this.userInfo.value = userInfo;
    storage.write('user_info', userInfo);
  }

  @override
  void onClose() {
    _internetConnectionStreamSubscription?.cancel();
    super.onClose();
  }
}
