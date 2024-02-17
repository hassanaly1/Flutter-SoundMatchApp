import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/models/songs_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';

class AddChallengeController extends GetxController {
  RxBool isSoundPackSelected = false.obs;
  RxBool isMemberSelected = false.obs;
  RxInt gameRound = 1.obs;
  TextEditingController challengeNameController = TextEditingController();
  TextEditingController numberOfRounds = TextEditingController();

  //ParticipantsList
  RxList<Member> selectedMembers = <Member>[].obs; //for selectedMembers
  RxList<Member> filteredMembers = <Member>[].obs; //for searching

  //SoundPackList
  RxList<SoundPackModel> soundPacks = <SoundPackModel>[
    SoundPackModel(
      packName: 'Imagine Pack',
      packImage:
          'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      isPaid: false,
      songs: [
        SongsModel(
          songName: 'Imagine 1',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 2',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 3',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 4',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 5',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 6',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 7',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 8',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 9',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Imagine 10',
          songImage:
              'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
      ],
    ),
    SoundPackModel(
      packName: 'Bohemian Rhapsody Pack',
      packImage:
          'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
      isPaid: false,
      songs: [
        SongsModel(
          songName: 'Bohemian Rhapsody 1',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 2',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 3',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 4',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 5',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 6',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 7',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 8',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 9',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
        SongsModel(
          songName: 'Bohemian Rhapsody 10',
          songImage:
              'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
        ),
      ],
    ),
  ].obs;

  //the sound user selects while creating the challenge
  Rx<SoundPackModel?> selectedSoundPack = Rx<SoundPackModel?>(null);
  Rx<SongsModel?> selectedSong = Rx<SongsModel?>(null);

  // RxList<SongsModel> usersSongs = <SoundPackModel>[
  //   SongsModel(
  //     songName: 'Imagine',
  //     songImage:
  //         'https://img.freepik.com/free-photo/caucasian-woman-s-portrait-isolated-blue-background-multicolored-neon-light_155003-32526.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
  //     isPaid: false,
  //   ),
  //   SongsModel(
  //     songName: 'Bohemian Rhapsody',
  //     songImage:
  //         'https://img.freepik.com/free-photo/one-young-woman-singing-sensually-stage-generated-by-ai_188544-25352.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
  //     isPaid: false,
  //   ),
  //   SongsModel(
  //     songName: 'Hotel California',
  //     songImage:
  //         'https://img.freepik.com/free-psd/neon-poster-template-electronic-music-with-female-dj_23-2148979680.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.1.1091155359.1700008188&semt=sph',
  //     isPaid: false,
  //   ),
  // ].obs;
  RxList<ChallengeModel> challenges = <ChallengeModel>[
    ChallengeModel(
        challengeName: 'Free Sound Match',
        song: SongsModel(songName: '', songImage: '')),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    addListener(() {});
    filteredMembers.assignAll(members);
  }

  void updateGameRound(String value) {
    gameRound.value = int.parse(value);
  }

  void filterMembers(String query) {
    filteredMembers.assignAll(members
        .where((member) =>
            member.name!.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  void addMembers(Member member) {
    if (selectedMembers.contains(member)) {
      selectedMembers.remove(member);
    } else {
      selectedMembers.add(member);
    }
  }

  void addSoundPack(SoundPackModel soundPack) {
    if (soundPacks.contains(soundPack)) {
      soundPacks.remove(soundPack);
      debugPrint(soundPack.packName);
      if (selectedSoundPack.value == soundPack) {
        // If the same sound is tapped again, deselect it
        isSoundPackSelected.value = false;
        selectedSoundPack.value = null;
      }
    } else {
      soundPacks.add(soundPack);
      debugPrint(soundPack.packName);
    }
  }

  void selectSound(SongsModel songsModel) {
    if (selectedSong.value == songsModel) {
      // If the same sound is tapped again, deselect it
      isSoundPackSelected.value = false;
      selectedSong.value = null;
    } else {
      // Deselect the previously selected sound
      isSoundPackSelected.value = false;

      // Select the new sound
      isSoundPackSelected.value = true;
      selectedSong.value = songsModel;
    }
  }

  void createChallenge(ChallengeModel challenge) {
    if (!challenges.contains(challenge)) {
      challenges.add(challenge);
      debugPrint('Challenges Length : ${challenges.length.toString()}');
    }
  }

  Rx<ChallengeModel> challengeModel =
      ChallengeModel(participants: [], challengeName: "").obs;

  void updateChallengeModel(ChallengeModel updatedModel) {
    challengeModel.value = updatedModel;
  }
}
