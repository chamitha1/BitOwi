import 'package:flutter/material.dart';
import 'package:BitOwi/core/storage/storage_service.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  bool _isTbaySelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffECEFF5), width: 0.72),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 230,
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xffF6F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffECEFF5), width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isTbaySelected = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isTbaySelected
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isTbaySelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            "Tbay",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _isTbaySelected
                                  ? const Color(0xff151E2F)
                                  : const Color(0xff929EB8),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isTbaySelected = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_isTbaySelected
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(),
                          boxShadow: !_isTbaySelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            "Cardgoal",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: !_isTbaySelected
                                  ? const Color(0xff151E2F)
                                  : const Color(0xff929EB8),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsGeometry.fromLTRB(10, 18, 10, 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(width: 0.72, color: const Color(0xffECEFF5)),
            ),
            child: Row(
              children: [
                Image.asset(
                  _isTbaySelected
                      ? "assets/images/home/tbay.png"
                      : "assets/images/home/cardgoal.png",
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Points",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff454F63),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _isTbaySelected ? "3,123" : "2,345",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff151E2F),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff1D5DE5), Color(0xff174AB7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/home/arrow_swap.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Swap to USDT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
