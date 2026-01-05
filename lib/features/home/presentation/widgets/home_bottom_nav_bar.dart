import 'package:flutter/material.dart';

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
            color: Color(0xff0E2B680F).withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1D5DE5),
        unselectedItemColor: const Color(0xff454F63),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xff454F63),
        ),
        elevation: 0,
        items: [
          _navItem("assets/icons/home/home.png", "Home", 0),
          _navItem("assets/icons/home/p2p.png", "P2P", 1),
          // _navItem("assets/icons/home/order.png", "Order", 2),
          _navItem("assets/icons/home/profile.png", "Profile", 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(String iconPath, String label, int index) {
    final isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xff1D5DE5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
                color: Colors.white,
              ),
            )
          : Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: const Color(0XFF717F9A),
            ),
      label: label,
    );
  }
}
