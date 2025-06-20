import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/auth/signup/sign_up_form.dart';
import 'package:yallabina/features/auth/signup/signup_controller.dart';
import '../../../core/constant/colors.dart';
import 'class_selection_screen.dart';

class SignUpView extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkestHeading,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 4.0,
        iconTheme: const IconThemeData(color: AppColors.darkestHeading),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background.withOpacity(0.9),
              AppColors.primary.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  secondary: AppColors.primary,
                ),
              ),
              child: Stepper(
                currentStep: controller.currentStep.value,
                onStepContinue: controller.nextStep,
                onStepCancel: controller.previousStep,
                elevation: 2,
                type: StepperType.vertical,
                steps: [
                  Step(
                    title: const Text(
                      'Basic Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    content: BasicInfoForm(),
                    isActive: controller.currentStep.value >= 0,
                    state: controller.currentStep.value > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text(
                      'Select Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    content: ClassSelection(),
                    isActive: controller.currentStep.value >= 1,
                    state: controller.currentStep.value > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                      title: const Text(
                        'Select Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      content: controller.selectedImagePath.isNotEmpty
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(
                                  File(controller.selectedImagePath.value)))
                          : ElevatedButton.icon(
                              onPressed: () => controller.pickImage(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.image),
                              label: const Text('Select Profile Image'),
                            ))
                ],
                controlsBuilder: (context, details) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      children: [
        if (details.currentStep > 0)
          ElevatedButton(
            onPressed: details.onStepCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: AppColors.primary,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Back'),
          ),
        const SizedBox(width: 16),
        if (details.currentStep < 2)
          ElevatedButton(
            onPressed: details.onStepContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Next'),
          ),
        if (details.currentStep == 2 && controller.classId.value != 0 && controller.selectedImagePath.isNotEmpty)
          ElevatedButton(
            onPressed: controller.signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Obx(() => controller.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Sign Up')),
          ),
      ],
    ),
  );
},
              ),
            );
          }),
        ),
      ),
    );
  }
}
