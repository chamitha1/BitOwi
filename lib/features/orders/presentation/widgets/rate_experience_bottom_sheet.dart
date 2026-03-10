import 'package:BitOwi/core/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';

class RateExperienceBottomSheet extends StatefulWidget {
  final String orderId;
  final VoidCallback onSuccess;

  const RateExperienceBottomSheet({
    super.key,
    required this.orderId,
    required this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required String orderId,
    required VoidCallback onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          RateExperienceBottomSheet(orderId: orderId, onSuccess: onSuccess),
    );
  }

  @override
  State<RateExperienceBottomSheet> createState() =>
      _RateExperienceBottomSheetState();
}

class _RateExperienceBottomSheetState extends State<RateExperienceBottomSheet> {
  // null = not selected, true = positive, false = negative
  bool? _isPositive;
  final Set<String> _selectedTags = {};
  bool _isLoading = false;

  final List<String> _positiveTags = [
    "Fast Trade",
    "Good Price",
    "Professional",
    "Reliable",
    "Responsive",
  ];

  final List<String> _negativeTags = [
    "Slow Response",
    "Bad Price",
    "Complicated",
    "Unreliable",
    "Unresponsive",
  ];

  void _onSentimentSelected(bool isPositive) {
    setState(() {
      if (_isPositive == isPositive) {}
      _isPositive = isPositive;
      _selectedTags.clear(); // Clear tags when switching like/dislike
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  Future<void> _submitReview() async {
    if (_isPositive == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));

      Get.back(); // Close sheet
      widget.onSuccess();
      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Review submitted successfully",
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Failed to submit review",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDAE0EE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                "Rate Your Experience",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151E2F),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                "Help others by sharing your trading experience",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffffffff),
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Like dislike Cards
                    Row(
                      children: [
                        Expanded(child: _buildSentimentCard(true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSentimentCard(false)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Tags Section
                    if (_isPositive != null) ...[
                      const Text(
                        "Select relevant tags (optional)",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8, // Gap between tags
                        runSpacing: 12, // Gap between lines
                        children: (_isPositive! ? _positiveTags : _negativeTags)
                            .map((tag) {
                              return _buildTagChip(tag);
                            })
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFECEFF5))),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isPositive == null || _isLoading
                            ? null
                            : _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPositive == null
                              ? const Color(0xFFB9C6E2) // Disabled color
                              : _isPositive!
                              ? const Color(0xFF1D5DE5) // Positive
                              : const Color(0xFFE74C3C), // Negative
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: const Color(0xFFB9C6E2),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CustomLoader(width: 24, height: 24),
                              )
                            : const Text(
                                "Submit Review",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF717F9A),
                      ),
                      child: Text(
                        _isPositive == null ? "Cancel" : "Maybe Later",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF717F9A),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ), 
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSentimentCard(bool isPositiveCard) {
    // Current state
    bool isSelected = _isPositive == isPositiveCard;

    Color borderColor = const Color(0xFFECEFF5); // Default border
    Color bgColor = Colors.white; // Default bg
    Color iconCircleBg = const Color(0xFFF6F9FF); // Default icon circle bg
    Color iconColor = const Color(0xFFB9C6E2); // Default icon colo
    Color textColor = const Color(0xFF151E2F); // Default text color

    if (isSelected) {
      if (isPositiveCard) {
        // Positive Selected
        borderColor = const Color(0xFF2ECC71);
        bgColor = const Color(0xFFEAF9F0);
        iconCircleBg = const Color(0xFF2ECC71);
        iconColor = Colors.white;
        textColor = const Color(0xFF40A372);
      } else {
        // Negative Selected
        borderColor = const Color(0xFFF5B7B1);
        bgColor = const Color(0xFFFDF4F5);
        iconCircleBg = const Color(0xFFE74C3C);
        iconColor = Colors.white;
        textColor = const Color(0xFFCF4436);
      }
    }

    return GestureDetector(
      onTap: () => _onSentimentSelected(isPositiveCard),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconCircleBg,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                isPositiveCard
                    ? 'assets/icons/orders/like.svg'
                    : 'assets/icons/orders/dislike.svg',
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isPositiveCard ? "Positive" : "Negative",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    bool isSelected = _selectedTags.contains(tag);

    // Default Style
    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFECEFF5);
    Color textColor = const Color(0xFF151E2F);

    if (isSelected) {
      if (_isPositive!) {
        // Positive Selected Tag
        bgColor = const Color(0xFFEAF9F0);
        borderColor = const Color(0xFFABEAC6);
        textColor = const Color(0xFF2ECC71);
      } else {
        // Negative Selected Tag
        bgColor = const Color(0xFFFDF4F5);
        borderColor = const Color(0xFFF5B7B1);
        textColor = const Color(0xFFE74C3C);
      }
    }

    return GestureDetector(
      onTap: () => _toggleTag(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
