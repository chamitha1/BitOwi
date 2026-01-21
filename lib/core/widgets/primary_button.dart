import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool showArrow;
  final Widget? child;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.showArrow = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor = enabled ? Colors.white : const Color(0xFF717F9A);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? const Color(0xFF1D5DE5)
              : const Color(0xFFB9C6E2),
          disabledBackgroundColor: const Color(0xFFB9C6E2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: contentColor,
                  ),
                ),
                if (showArrow) ...[
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    'assets/icons/public/arrow_right_long.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      contentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
      ),
    );
  }
}
