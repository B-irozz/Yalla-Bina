import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';


void showLoading() {
  Get.dialog(
    const Center(
      child: AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
                strokeAlign: 0.02,
              ),
              SizedBox(height: 16),
              Text(
                "جارى التحميل...",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void hideLoading() {
  Get.back();
}

void showErrorDialog(String message) {
  Get.dialog(
    AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Icon(
                Icons.error_outline_rounded,
                size: 50,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "حسنا",
                style: TextStyle(fontSize: 14
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void showSuccessAlert(String message) {
  Get.dialog(
    AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Icon(
                Icons.check_circle_rounded,
                size: 60,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                "شكرا لك!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "حسنا",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
