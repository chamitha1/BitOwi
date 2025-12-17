import 'package:BitDo/features/auth/presentation/pages/login_screen.dart';
import 'package:BitDo/features/onboarding/models/onboarding_content.dart';
import 'package:BitDo/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding_1.png',
      subtitle: "Begin with Confidence",
      title: "Start Your Crypto Journey",
      description:
          "Begin exploring digital assets confidently with guided tools designed to help beginners learn, invest, and grow safely.",
    ),
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding_2.png',
      subtitle: "Your Assets, Always Protected",
      title: "Safe & Smart Transactions",
      description:
          "Experience fast, secure transactions supported by advanced encryption and monitoring to keep your crypto assets fully protected.",
    ),
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding_3.png',
      subtitle: "Simplify Your Crypto Journey",
      title: "Manage Everything in One Place",
      description:
          "Effortlessly control your entire crypto portfolio with seamless tools for buying, storing, sending, and tracking assets.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _goToLogin(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0XFF717F9A),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(content: _pages[index]);
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 24 : 6,
                  decoration: BoxDecoration(
                    gradient: _currentPage == index
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
                          )
                        : null,
                    color: _currentPage == index ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _goToLogin();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
