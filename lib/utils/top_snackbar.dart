import 'package:flutter/material.dart';

class TopSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12,
        right: 12,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Otomatis hilang setelah 2.5 detik
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  // Notifikasi Berhasil / Tambah (Hijau)
  static void showSuccess(BuildContext context, String title, String message) {
    show(
      context,
      title: title,
      message: message,
      backgroundColor: const Color(0xFF4CAF50),
    );
  }

  // Notifikasi Gagal / Hapus (Merah)
  static void showError(BuildContext context, String title, String message) {
    show(
      context,
      title: title,
      message: message,
      backgroundColor: const Color(0xFFE53935),
    );
  }
}