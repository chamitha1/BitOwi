import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: const AssetImage("assets/images/home/avatar.png"),
          backgroundColor: Color(0xffD9D9D9),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Jonathan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0XFF332C3B),
                fontFamily: 'Inter',
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Welcome to  ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff83869D),
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'BitDo',
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
        const Spacer(),
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
