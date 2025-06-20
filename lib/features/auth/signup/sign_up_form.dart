import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/auth/signup/signup_controller.dart';

import '../../../core/constant/colors.dart';

class BasicInfoForm extends StatelessWidget {
  final SignUpController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: const TextStyle(color: AppColors.primary),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
            ),
            onChanged: (value) => controller.username.value = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: AppColors.primary),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.email, color: AppColors.primary),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.email.value = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(color: AppColors.primary),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
            ),
            obscureText: true,
            onChanged: (value) => controller.password.value = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: const TextStyle(color: AppColors.primary),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            ),
            obscureText: true,
            onChanged: (value) => controller.confirmationPassword.value = value,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Gender',
              labelStyle: const TextStyle(color: AppColors.primary),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
            ),
            items: ['male', 'female',]
                .map((gender) => DropdownMenuItem(
              value: gender,
              child: Text(gender),
            ))
                .toList(),
            onChanged: (value) => controller.gender.value = value!,
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
