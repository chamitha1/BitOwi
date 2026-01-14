import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/notifications/presentation/pages/notifications_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Row(
      children: [
        Obx(
          () => Container(
            height: 52,
            width: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD9D9D9),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: CommonImage(
                controller.userAvatar.value,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  "Hi, ${controller.userName.value}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0XFF332C3B),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Welcome to  ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff83869D),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'BitOwi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xff151E2F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Get.to(() => const NotificationsPage())?.then((_) {
              controller.fetchNotificationCount();
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _headerIconButton("assets/icons/home/notification.svg"),
              Obx(() {
                if (controller.notificationCount.value > 0) {
                  return Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D4F),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          controller.notificationCount.value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // _headerIconButton("assets/icons/home/headphones.png"),
      ],
    );
  }

  Widget _headerIconButton(String iconPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xffECEFF5),
        shape: BoxShape.circle,
      ),
      child: Center(child: SvgPicture.asset(iconPath, width: 20, height: 20)),
    );
  }
}
