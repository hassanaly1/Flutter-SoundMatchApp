import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/view/soundpacks/sound_pack_list.dart';

class CustomSoundPackWidget extends StatelessWidget {
  final SoundPackModel soundPackModel;
  final MyUniversalController controller = Get.find();

  CustomSoundPackWidget({super.key, required this.soundPackModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          controller.soundsById.clear();
          controller.fetchSoundsByPackId(soundPackModel.id);
          debugPrint('SoundsLength: ${controller.soundsById.length}');
          Get.to(
            () => SoundPackList(
              soundPackModel: soundPackModel,
              sounds: controller.soundsById,
            ),
            transition: Transition.zoom,
            duration: const Duration(milliseconds: 500),
          );
        },
        child: Container(
          height: context.height * 0.2,
          width: context.width * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImage(context),
              _buildTextInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              height: context.height * 0.12,
              soundPackModel.packImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildPaidFreeLabel(),
          _buildAddRemoveButton(),
          if (soundPackModel.isPaid) _buildPriceLabel(),
        ],
      ),
    );
  }

  Widget _buildTextInfo() {
    return CustomTextWidget(
      text: soundPackModel.packName,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      textColor: Colors.black,
    );
  }

  Widget _buildPaidFreeLabel() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white70,
        ),
        child: CustomTextWidget(
          text: soundPackModel.isPaid ? 'Paid' : 'Free',
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          textColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildPriceLabel() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white70,
        ),
        child: CustomTextWidget(
          text: '\$${soundPackModel.price}',
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          textColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildAddRemoveButton() {
    bool isSoundPackAdded = controller.userSoundPacks
        .any((soundPack) => soundPack.id == soundPackModel.id);
    return Positioned(
      top: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          isSoundPackAdded
              ? null
              : soundPackModel.isPaid
                  ? controller.addPaidSoundPack(soundPackModel)
                  : controller.addFreeSoundPack(soundPackModel);
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSoundPackAdded ? Colors.lightGreen : Colors.white70,
          ),
          child: Icon(
            isSoundPackAdded ? Icons.done : Icons.add,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
