import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? action;

  const CommonEmptyState({
    super.key,
    required this.title,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, -0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          emptyImage(),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF151E2F),
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description.toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF717F9A),
                // height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }

  Stack emptyImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xFFE8EFFF),
            shape: BoxShape.circle,
          ),
        ),
        SvgPicture.asset(
          'assets/icons/public/empty-icon.svg',
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
