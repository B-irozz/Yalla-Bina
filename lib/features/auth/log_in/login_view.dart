import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/core/app_responsive.dart';
import 'package:yallabina/core/constant/colors.dart';
import '../signup/signup_view.dart';
import 'login_controller.dart';
import '../resetPass_and_confirmMail/forget_password_screen.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    // تحقق إذا كان الـ controller موجود، لو لا أنشئ واحد جديد
    controller = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
  }

  @override
  void dispose() {
    // إزالة الـ controller إذا كان موجود
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background.withOpacity(0.9),
              AppColors.primary.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "يلا بينا",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.h()),
                Text(
                  "تعلم وتنافس بكل سهولة",
                  style: TextStyle(
                    fontSize: 18.s(),
                    color: AppColors.text,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 50.h()),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: "البريد الإلكتروني",
                      hintStyle: const TextStyle(color: AppColors.text),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: 20.h()),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscureText.value,
                        decoration: InputDecoration(
                          hintText: "كلمة المرور",
                          hintStyle: const TextStyle(color: AppColors.text),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureText.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.primary,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 20.h()),
                ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                SizedBox(height: 20.h()),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ForgetPasswordScreen(resetPass: true, email: controller.emailController.text));
                    },
                    child: const Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontFamily: 'Cairo',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ليس لدي حساب؟ ",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUpView());
                      },
                      child: const Text(
                        "إنشاء حساب",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}