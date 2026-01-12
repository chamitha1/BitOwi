import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0E2B680F).withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                "assets/icons/home/home.svg",
                "assets/icons/home/homeSelected.svg",
                "Home",
                0,
              ),
              _navItem(
                "assets/icons/home/p2p.svg",
                "assets/icons/home/p2pSelected.svg",
                "P2P",
                1,
              ),
              _navItem(
                "assets/icons/home/orders.svg",
                "assets/icons/home/ordersSelected.svg",
                "Order",
                2,
              ),
              _navItem(
                "assets/icons/home/profile.svg",
                "assets/icons/home/profileSelected.svg",
                "Profile",
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    String iconPath,
    String selectedIconPath,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: isSelected
              ? Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff1D5DE5), Color(0xff28A6FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(selectedIconPath, width: 20, height: 20),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(iconPath, width: 22, height: 22),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xff717F9A),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
