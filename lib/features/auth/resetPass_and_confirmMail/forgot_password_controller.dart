import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:yallabina/core/data/repos/auth_repos/forgetPassword/check_forget_code_repo.dart';
import 'package:yallabina/core/data/repos/auth_repos/forgetPassword/reset_password_repo.dart';
import 'package:yallabina/core/utils/dialog_utils.dart';
import 'package:yallabina/core/data/models/failures.dart';
import 'package:yallabina/features/auth/log_in/login_view.dart';
import '../../../core/data/utils/shared_pref_utils.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  String initialEmail = '';
  final List<TextEditingController> mobileControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final CheckForgetPasswordRepo checkForgetPasswordRepo = CheckForgetPasswordRepo();
  final ResetPasswordRepo resetPasswordRepo = ResetPasswordRepo();

  var phone = false.obs;
  var changePass = false.obs;
  var isPassword = true.obs;
  var isConPassword = true.obs;
  var remainingSeconds = 180.obs;
  var formKey = GlobalKey<FormState>();
  String? resetToken;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    if (emailController.text.isNotEmpty) {
      initialEmail = emailController.text.trim();
    }
  }

  void startTimer() {
    if (remainingSeconds.value > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        remainingSeconds.value--;
        startTimer();
      });
    }
  }

  void showPassword() => isPassword.value = !isPassword.value;
  void showConPassword() => isConPassword.value = !isConPassword.value;

  void onChanged(String value, int index, BuildContext context) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
    if (index == 5 && value.isNotEmpty) FocusScope.of(context).unfocus();
  }

  void getForgetAccount() async {
    showLoading();
    Either<Failure, bool> either = await checkForgetPasswordRepo.forgetPassword(emailController.text.trim());
    hideLoading();
    either.fold(
      (error) => showErrorDialog(error.errorMessage ?? "يوجد خطأ ما!"),
      (success) {
        phone.value = true;
        changePass.value = false;
      },
    );
  }

  void reSendCode() {
    remainingSeconds.value = 180;
    getForgetAccount();
  }

  void resetPassword() async {
    showLoading();
    String code = mobileControllers.map((char) => char.text).join();
    String email = initialEmail.isNotEmpty ? initialEmail : emailController.text.trim();
    if (email.isEmpty) {
      hideLoading();
      showErrorDialog("Email is required!");
      return;
    }
    print("Reset: email=$email, OTP=$code, password=${passwordController.text}, time=${DateTime.now()}");
    Either<Failure, String> either = await resetPasswordRepo.resetPassword(
      phone: email,
      code: code,
      password: passwordController.text,
    );
    hideLoading();
    either.fold(
      (error) {
        print("Reset Error: ${error.errorMessage ?? 'Unknown error'}");
        showErrorDialog(error.errorMessage ?? "يوجد خطأ ما!");
      },
      (success) {
        showSuccessAlert(success);
        Future.delayed(const Duration(seconds: 2), () {
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.delete<ForgetPasswordController>();
            Get.offAndToNamed('/LoginScreen');
          });
        });
      },
    );
  }

  void changePassDone() {
    Get.back();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void onClose() {
    emailController.dispose();
    for (var controller in mobileControllers) controller.dispose();
    for (var node in focusNodes) node.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}