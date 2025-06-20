import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/auth/signup/signup_view.dart';
import 'package:yallabina/features/auth/resetPass_and_confirmMail/forget_password_screen.dart';
import '../../exam/screens/subjects/subjects_view.dart'; // هنعرض شاشة المواد هنا
import '../../../core/data/repos/auth_repos/Login/login_repo.dart';
import 'package:yallabina/features/home/screens/main_screen.dart';
import '../../../core/data/utils/shared_pref_utils.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../core/data/repos/subjects/subjects_repo.dart'; // عشان المواد
import '../../exam/screens/subjects/subjects_controller.dart'; // الكنترولر بتاع المواد
import '../../../core/data/models/responses/authResponse/login_response.dart'; // عشان UserDM

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SharedPrefUtils sharedPrefUtils = SharedPrefUtils();
  final LoginRepo loginRepo = LoginRepo(SharedPrefUtils());

  var obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<void> login() async {
    showLoading();
    final result = await loginRepo.login(
      password: passwordController.text,
      email: emailController.text,
    );
    hideLoading();

    result.fold(
      (failure) {
        print("❌ Login Failure: ${failure.errorMessage}");
        showErrorDialog(failure.errorMessage);
      },
      (user) async {
        print("✅ Login Success: ${user.name}");

        // تحميل بيانات المستخدم من Shared Preferences للتأكد
        final savedUser = await sharedPrefUtils.getUser();
        print("📦 Saved user after login: ${savedUser?.name}");

        // تحميل المواد بناءً على المستخدم الجديد
        final subjectsController = Get.put(SubjectsController());
        await subjectsController.fetchSubjects();

        showSuccessAlert("تم تسجيل الدخول بنجاح");

        // الانتقال إلى شاشة المواد مباشرة
        Get.offAll(() => MainScreen());
      },
    );
  }

  void forgotPassword() {
    Get.to(() => ForgetPasswordScreen(
          resetPass: true,
          email: emailController.text,
        ));
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}