import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sound_app/data/challenge_service.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/all_challenges_model.dart';

class AllChallengesSection extends StatefulWidget {
  const AllChallengesSection({super.key});

  @override
  State<AllChallengesSection> createState() => _AllChallengesSectionState();
}

class _AllChallengesSectionState extends State<AllChallengesSection> {
  var allChallenges = <AllChallengesModel>[].obs;
  RxBool isLoading = false.obs;

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    getAllChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : allChallenges.isEmpty
              ? const Center(
                  child: CustomTextWidget(
                    text: "You have not created any challenge",
                    textColor: MyColorHelper.white,
                    maxLines: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : ListView.builder(
                  itemCount: allChallenges.length,
                  itemBuilder: (context, index) {
                    final challenge = allChallenges[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.top,
                          title: CustomTextWidget(
                            text: challenge.name ?? '',
                            fontFamily: 'Horta',
                            fontSize: 24,
                          ),
                          trailing: CustomTextWidget(
                            text: formatDate(challenge.createdAt?.toUtc()),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text:
                                    'Winner: ${challenge.winner?.participant?.firstName}',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextWidget(
                                text:
                                    'Total Participants: ${challenge.totalparticipants.toString()}',
                                maxLines: 2,
                              ),
                              CustomTextWidget(
                                text:
                                    'Total Challenges: ${challenge.numberOfChallenges}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> getAllChallenges() async {
    allChallenges.clear();
    try {
      isLoading.value = true;

      // Get all challenges
      var challenges = await ChallengeService().fetchAllChallenges();
      if (challenges != null) {
        allChallenges.assignAll(challenges);
        debugPrint('Challenges fetched: ${allChallenges.length}');
      } else {
        debugPrint('No challenges fetched.');
      }
    } catch (e) {
      debugPrint('Error Fetching Challenges: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
