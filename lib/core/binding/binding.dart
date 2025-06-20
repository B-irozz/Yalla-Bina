// lib/core/bindings/app_binding.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/core/data/utils/shared_pref_utils.dart';
import '../service/socket.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize services
    Get.put<SocketService>(
      SocketService(),
      permanent: true,
    );
    Get.put<Dio>(Dio());
    Get.put<SharedPrefUtils>(SharedPrefUtils()..init());

    // Check token and set initial route
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    // Wait a bit for SharedPrefUtils to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();
    String? token = await sharedPrefUtils.getToken();

    if (token != null && token.isNotEmpty) {
      // Navigate to main screen if token exists
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/MainScreen');
      });
    }
  }
}