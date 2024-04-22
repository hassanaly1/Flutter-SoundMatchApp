import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/add_challenge_controller.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/participant_model.dart';

class CustomParticipantWidget extends StatelessWidget {
  final Participant member;
  final bool? showAddIcon;
  final bool? showTickIcon;

  const CustomParticipantWidget({
    super.key,
    required this.member,
    this.showAddIcon = true,
    this.showTickIcon,
  });

  @override
  Widget build(BuildContext context) {
    final AddChallengeController controller =
        Get.find<AddChallengeController>();

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: InkWell(
        onTap: () {
          controller.addMembers(member);
        },
        child: Container(
          color: Colors.transparent,
          width: 60,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //     member.imageUrl.toString(),
                      //   ),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Image.network(
                      member.imageUrl.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  CustomTextWidget(
                    text: member.name.toString(),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'poppins',
                    textColor: Colors.white,
                  ),
                ],
              ),
              showTickIcon == true
                  ? Obx(
                      () => Visibility(
                        visible: controller.isMemberSelected.value &&
                            controller.filteredMembers.contains(member),
                        child: Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightGreen),
                            child: const Icon(
                              Icons.done,
                              size: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Obx(
                      () => Visibility(
                        visible: showAddIcon == true,
                        child: Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              controller.addMembers(member);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.selectedMembers
                                          .contains(member)
                                      ? Colors.lightGreen
                                      : Colors.white70),
                              child: Icon(
                                controller.selectedMembers.contains(member)
                                    ? Icons.done
                                    : Icons.add,
                                size: 22,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
