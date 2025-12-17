import 'package:BitDo/features/auth/presentation/pages/login_screen.dart';
import 'package:BitDo/features/onboarding/presentation/onboarding_page.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    OnboardingPage(
                      image: 'assets/images/rocket.png',
                      iconSize: 60.0,
                      title: "Start Your Crypto Journey",
                      description:
                          "Begin exploring digital assets confidently with guided tools designed to help beginners learn, invest, and grow safely.",
                      currentPage: _currentPage,
                    ),
                    OnboardingPage(
                      image: 'assets/images/currency-exchange.png',
                      iconSize: 120.0,
                      title: "Safe & Smart Transactions",
                      description:
                          "Experience fast, secure transactions supported by advanced encryption and monitoring to keep your crypto assets fully protected.",
                      currentPage: _currentPage,
                    ),
                    OnboardingPage(
                      image: 'assets/images/cryptocurrency.png',
                      title:
                          "Simplify Your Crypto Journey \n Manage Everything in One Place",
                      iconSize: 210.0,
                      description:
                          "Effortlessly control your entire crypto portfolio with seamless tools for buying, storing, sending, and tracking assets.",
                      currentPage: _currentPage,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isCurrentPage = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isCurrentPage ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isCurrentPage
                          ? const Color.fromARGB(255, 147, 104, 231)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
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
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 156, 110, 248),
                          Color.fromARGB(255, 71, 26, 217),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _currentPage == 2 ? "Get Started" : "Next",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
}
