import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/profile.dart';

class HomeController extends GetxController {
  int selectedIndex = 0;
  String studentCode = '';

  void onItemTapped(int index, BuildContext context) {
    selectedIndex = index;
    update(); // This will trigger GetBuilder to rebuild

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  void showCodeDialog(BuildContext context) {
    TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ادخل كود الطالب"),
        content: TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "مثال: 123456"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              studentCode = codeController.text;
              update(); // Notify listeners
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }
}