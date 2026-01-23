import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class P2PEmptyState extends StatelessWidget {
  const P2PEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, -0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
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
                'assets/icons/p2p/empty-icon.svg',
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "No Ads Available",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF151E2F),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Post an ad to start trading with others.",
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
      ),
    );
  }
}
