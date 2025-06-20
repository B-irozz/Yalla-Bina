import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/core/app_responsive.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:yallabina/core/theming/text_styles.dart';
import 'package:yallabina/core/widgets/custom_text_form_field.dart';
import 'package:yallabina/core/widgets/primary_colored_button.dart';
import 'forgot_password_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final bool resetPass;
  final String email;
  ForgetPasswordScreen({super.key, required this.resetPass, required this.email});

  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    if (controller.emailController.text.isEmpty) {
      controller.emailController.text = email.isNotEmpty ? email : '';
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 20,
        title: Text(resetPass ? "forgot Password".tr : "loginByOtp".tr, textAlign: TextAlign.right),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h()),
              accountRecovery(context),
              confirmPhoneNumber(context),
              changePassword(context),
            ],
          ),
        );
      }),
    );
  }

  Widget accountRecovery(BuildContext context) {
    return Visibility(
      visible: !controller.phone.value && !controller.changePass.value,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              validator: (value) {
                if (value!.trim().isEmpty) return "Email required".tr;
                return null;
              },
              labelText: 'Enter your email'.tr,
              controller: controller.emailController,
              labelColor: AppColors.shade_95,
            ),
            SizedBox(height: 20.h()),
            PrimaryColoredButton(
              buttonText: "send".tr,
              onPressed: controller.getForgetAccount,
            ),
          ],
        ),
      ),
    );
  }

  Widget confirmPhoneNumber(BuildContext context) {
    return Visibility(
      visible: controller.phone.value && !controller.changePass.value,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("confirmEmail", textAlign: TextAlign.center, style: TextStyles.font22DarkestBold),
            SizedBox(height: 20.h()),
            Text("${"verification Code Sent".tr} ${controller.emailController.text}", textAlign: TextAlign.center, style: TextStyles.font14GrayNormal),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 45.w(),
                    height: 40.h(),
                    margin: EdgeInsets.symmetric(horizontal: 6.w()),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8.s()),
                    ),
                    child: CustomTextFormField(
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      controller: controller.mobileControllers[index],
                      focusNode: controller.focusNodes[index],
                      keyboardType: TextInputType.number,
                      border: InputBorder.none,
                      counterText: '',
                      onChanged: (value) {
                        controller.onChanged(value!, index, context);
                        return null;
                      },
                    ),
                  );
                }),
              ),
            ),
            Obx(() {
              return Row(
                children: [
                  TextButton(
                    onPressed: controller.remainingSeconds.value == 0 ? controller.reSendCode : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4.h()),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: controller.remainingSeconds.value != 0 ? AppColors.shade_9.withOpacity(0.6) : AppColors.shade_9,
                          width: 1,
                        )),
                      ),
                      child: Text("resend Code".tr, style: TextStyles.font10DarkestNormal.copyWith(
                        fontSize: 12.s(),
                        color: controller.remainingSeconds.value != 0 ? AppColors.shade_9.withOpacity(0.6) : AppColors.shade_9,
                      )),
                    ),
                  ),
                  SizedBox(width: 10.w()),
                  Text(controller.formatTime(controller.remainingSeconds.value), style: TextStyles.font12PrimaryNormal.copyWith(fontSize: 14.s())),
                ],
              );
            }),
            SizedBox(height: 20.h()),
            CustomTextFormField(
              validator: (value) {
                if (value!.trim().isEmpty) return "Password required".tr;
                if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$').hasMatch(value))
                  return "password must be strong".tr;
                return null;
              },
              labelText: "New password".tr,
              controller: controller.passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 10.h()),
            PrimaryColoredButton(
              buttonText: "confirm".tr,
              onPressed: () {
                String otp = controller.mobileControllers.map((c) => c.text).join();
                if (controller.passwordController.text.isNotEmpty) {
                  controller.resetPassword();
                } else {
                  Get.snackbar("Error", "password required".tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              height: 40.h(),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePassword(BuildContext context) {
    return Visibility(
      visible: controller.changePass.value,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w()),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("createNewPassword".tr, textAlign: TextAlign.center, style: TextStyles.font22DarkestBold.copyWith(fontSize: 24.s())),
              SizedBox(height: 20.h()),
              Obx(() {
                return CustomTextFormField(
                  validator: (value) {
                    if (value!.trim().isEmpty) return "passwordRequired".tr;
                    return null;
                  },
                  labelText: "newPassword".tr,
                  obscureText: controller.isPassword.value,
                  controller: controller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: InkWell(
                    onTap: controller.showPassword,
                    child: Padding(
                      padding: EdgeInsets.all(8.s()),
                      child: Icon(controller.isPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20.s()),
                    ),
                  ),
                );
              }),
              Obx(() {
                return CustomTextFormField(
                  validator: (value) {
                    if (value!.trim().isEmpty) return "confirmPasswordRequired".tr;
                    if (controller.passwordController.text != value) return "Passwords do not match".tr;
                    return null;
                  },
                  controller: controller.confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  labelText: "confirmNewPassword".tr,
                  obscureText: controller.isConPassword.value,
                  suffixIcon: InkWell(
                    onTap: controller.showConPassword,
                    child: Padding(
                      padding: EdgeInsets.all(8.s()),
                      child: Icon(controller.isConPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20.s()),
                    ),
                  ),
                );
              }),
              PrimaryColoredButton(
                buttonText: "confirm".tr,
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.resetPassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}