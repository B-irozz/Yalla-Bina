import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yallabina/features/auth/log_in/login_view.dart';
import 'package:yallabina/features/exam/screens/FriendsListScreen.dart';
import 'package:yallabina/features/exam/screens/NotesScreen.dart';
import 'package:yallabina/features/exam/screens/chatbot.dart';
import 'package:yallabina/features/home/screens/main_screen.dart';
import 'core/app_responsive.dart';
import 'core/binding/binding.dart';
import 'features/onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'auth_token');
  runApp(MyApp(initialRoute: token == null ? '/LoginScreen' : '/MainScreen'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive.context = context;

    return GetMaterialApp(
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/LoginScreen', page: () => LoginView()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
        GetPage(name: '/FriendsListScreen', page: () => const FriendsListScreen()),
        GetPage(name: '/ChatBotScreen', page: () => const ChatBotScreen()),
        GetPage(name: '/NotesScreen', page: () => const NotesScreen()),
        GetPage(name: '/OnBoarding', page: () => const OnBoarding()),
      ],
    );
  }
}