import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/core/storage/storage_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage("assets/images/home/avatar.png"),
          backgroundColor: Color(0xffD9D9D9),
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
        _headerIconButton("assets/icons/home/notification.png"),
        const SizedBox(width: 12),
        _headerIconButton("assets/icons/home/headphones.png"),
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
      child: Center(child: Image.asset(iconPath, width: 20, height: 20)),
    );
  }
}
