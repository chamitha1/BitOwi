import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildIdUploadPlaceholder({
  required bool isUploading,
  required VoidCallback onPick,
}) {
  return DottedBorder(
    dashPattern: const [2, 4],
    strokeWidth: 1.5,
    borderType: BorderType.RRect,
    radius: const Radius.circular(16),
    color: const Color(0xFFB9C6E2),
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isUploading
          ? const SizedBox(
              height: 274,
              child: Center(child: SoftCircularLoader()),
            )
          : Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEFF6FF),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/merchant_details/upload.svg',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Upload ID Picture",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF151E2F),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Drag and drop your file here or",
                  style: TextStyle(fontSize: 12, color: Color(0xFF717F9A)),
                ),
                const SizedBox(height: 16),

                /// ⬆️ UPLOAD BUTTON
                ElevatedButton.icon(
                  onPressed: onPick,
                  icon: SvgPicture.asset(
                    'assets/icons/merchant_details/upload.svg',
                    height: 16,
                    width: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text(
                    "Click to Upload",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/merchant_details/personalcard.svg',
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "JPG or PNG only • Max 5MB",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF717F9A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRequirement("Clear, readable text on the document"),
                const SizedBox(height: 8),
                _buildRequirement("All four corners of the ID must be visible"),
                const SizedBox(height: 8),
                _buildRequirement("Photo taken in good lighting"),
              ],
            ),
    ),
  );
}

Widget _buildRequirement(String text) {
  return Row(
    children: [
      const Icon(
        Icons.check_circle_outline,
        color: Color(0xFF40A372),
        size: 14,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF717F9A),
          ),
        ),
      ),
    ],
  );
}

Widget buildUploadedIdPreview({
  required String faceUrl,
  required VoidCallback onPick,
  required VoidCallback onRemove,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Stack(
          children: [
            // ---------- IMAGE PREVIEW ----------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  faceUrl,
                  width: double.infinity,
                  height: 274,
                  fit: BoxFit.cover,

                  // ⏳ Loading indicator while image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      height: 274,
                      alignment: Alignment.center,
                      color: const Color(0xFFEFF6FF),
                      child: const SoftCircularLoader(),
                    );
                  },

                  // ❌ Error fallback
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 274,
                      alignment: Alignment.center,
                      color: const Color(0xFFEFF6FF),
                      child: const Text(
                        "Failed to load image",
                        style: TextStyle(
                          color: Color(0xFF717F9A),
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ---------- UPLOADED BADGE ----------
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF9F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Color(0xFF40A372),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Uploaded",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF40A372),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------- REMOVE BUTTON ----------
            Positioned(
              top: 14,
              right: 14,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE74C3C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),

            // ---------- BOTTOM ACTION BAR ----------
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECEFF5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: onPick,
                        icon: const Icon(
                          Icons.upload,
                          size: 18,
                          color: Color(0xFF1D5DE5),
                        ),
                        label: const Text(
                          "Upload Different Photo",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF1D5DE5),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1D5DE5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
