import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_pack_model.dart';

class CustomSoundAvatar extends StatelessWidget {
  final SoundPackModel soundPackModel;

  const CustomSoundAvatar({
    super.key,
    required this.soundPackModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.2,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            backgroundImage: NetworkImage(soundPackModel.packImage),
            radius: 40,
          ),
          const SizedBox(height: 6.0),
          CustomTextWidget(
            text: soundPackModel.packName,
            textColor: Colors.white,
            fontSize: 14.0,
            fontFamily: 'poppins',
            maxLines: 2,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}
