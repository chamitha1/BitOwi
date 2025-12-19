import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/wallet_card.dart';
import '../widgets/merchant_banner.dart';
import '../widgets/tab_section.dart';
import '../widgets/balance_section.dart';
import '../widgets/home_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              const WalletCard(),
              const SizedBox(height: 20),
              const MerchantBanner(),
              const SizedBox(height: 24),
              const TabSection(),
              const SizedBox(height: 24),
              const BalanceSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
      ),
    );
  }
}
