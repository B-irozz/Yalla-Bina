import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/auth/log_in/login_view.dart';
// Import your app colors file
import '../../../core/constant/colors.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Verify Email',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.email_outlined,
                size: 50,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            const Text(
              'Check Your Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'We\'ve sent a verification link to:',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Email address
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            const Text(
              'Click the verification link in your email to confirm your account.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),


            const SizedBox(height: 20),

            // Login button (for after verification)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to login screen
                  Get.offAll(() => LoginView()); // Replace with your login screen
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go to Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Resend email option
            TextButton(
              onPressed: () {
                // Add resend verification email logic here
                _resendVerificationEmail();
              },
              child: const Text(
                'Didn\'t receive the email? Resend',
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resendVerificationEmail() {
    Get.snackbar(
      'Email Sent',
      'Verification email has been resent to $email',
      backgroundColor: AppColors.lightGreen,
      colorText: AppColors.text,
      snackPosition: SnackPosition.TOP,
    );
  }
}