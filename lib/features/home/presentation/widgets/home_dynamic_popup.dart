import 'package:BitOwi/models/common_dynamic_popup.dart';
import 'package:flutter/material.dart';

class HomeDynamicPopup extends StatelessWidget {
  const HomeDynamicPopup({
    super.key,
    required this.popup,
    required this.onClose,
    this.onTap,
  });

  final CommonDynamicPopup popup;
  final VoidCallback onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: popup.hasImage
                  ? Image.network(
                      popup.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        height: 220,
                        child: Center(
                          child: Text('Failed to load popup image'),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 220,
                      child: Center(
                        child: Text('No popup image'),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: -12,
            right: -12,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 34,
                width: 34,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
