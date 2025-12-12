import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shows a glassy/frosted notification at the top with close button.
/// Multiple notifications stack vertically.
void showGlassySnackbar({
  required String title,
  required String message,
  required Color accentColor,
  IconData icon = Icons.info_outline,
  Duration duration = const Duration(seconds: 3),
  Widget? action,
}) {
  Get.snackbar(
    '',
    '',
    titleText: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (action != null) action,
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              if (Get.isSnackbarOpen) {
                Get.back();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    ),
    messageText: const SizedBox.shrink(),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    borderRadius: 14,
    duration: duration,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    animationDuration: const Duration(milliseconds: 350),
    snackbarStatus: (status) {},
    barBlur: 20,
    overlayBlur: 0,
    boxShadows: [
      BoxShadow(
        color: accentColor.withValues(alpha: 0.15),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
    backgroundGradient: LinearGradient(
      colors: Get.isDarkMode
          ? [
              Colors.grey.shade900.withValues(alpha: 0.85),
              Colors.grey.shade800.withValues(alpha: 0.75),
            ]
          : [
              Colors.white.withValues(alpha: 0.9),
              Colors.grey.shade100.withValues(alpha: 0.85),
            ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderColor: accentColor.withValues(alpha: 0.3),
    borderWidth: 1,
  );
}

/// Convenience wrappers
void showSuccessSnackbar(String title, String message) {
  showGlassySnackbar(
    title: title,
    message: message,
    accentColor: const Color(0xFF10B981),
    icon: Icons.check_circle_outline,
  );
}

void showErrorSnackbar(String title, String message) {
  showGlassySnackbar(
    title: title,
    message: message,
    accentColor: const Color(0xFFEF4444),
    icon: Icons.error_outline,
  );
}

void showInfoSnackbar(String title, String message) {
  showGlassySnackbar(
    title: title,
    message: message,
    accentColor: const Color(0xFF3B82F6),
    icon: Icons.info_outline,
  );
}

void showWarningSnackbar(String title, String message) {
  showGlassySnackbar(
    title: title,
    message: message,
    accentColor: const Color(0xFFF59E0B),
    icon: Icons.warning_amber_outlined,
  );
}

void showDeleteSnackbar({
  required String title,
  required String message,
  required VoidCallback onUndo,
}) {
  showGlassySnackbar(
    title: title,
    message: message,
    accentColor: const Color(0xFFEF4444),
    icon: Icons.delete_outline,
    duration: const Duration(seconds: 4),
    action: TextButton(
      onPressed: onUndo,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'گەڕاندنەوە',
        style: TextStyle(
          color: Color(0xFF10B981),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    ),
  );
}
