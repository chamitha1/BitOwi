import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerModal extends StatelessWidget {
  static final ImagePicker picker = ImagePicker();

  const ImagePickerModal({super.key});

  static Future<XFile?> showModal(
    BuildContext context, {
    bool isVideo = false,
  }) async {
    ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return const ImagePickerModal();
      },
    );
    if (source != null) {
      if (isVideo) {
        return picker.pickVideo(source: source);
      }
      return picker.pickImage(
        source: source,
        //  imageQuality: 75
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFB9C6E2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          _PickerTile(
            iconString: "assets/icons/merchant_details/camera.svg",
            title: 'Take a Picture',
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          _PickerTile(
            iconString: "assets/icons/merchant_details/gallery.svg",
            title: 'Upload from Picture Gallery',
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          Container(height: 40),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String iconString;
  final String title;
  final VoidCallback onTap;
  const _PickerTile({
    required this.iconString,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F9FF).withOpacity(0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconString,
                      width: 22,
                      height: 22,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF151E2F),
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/icons/merchant_details/ic_next.svg',
              width: 5.32,
              height: 11.88,
              colorFilter: const ColorFilter.mode(
                Color(0XFF47464F),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
