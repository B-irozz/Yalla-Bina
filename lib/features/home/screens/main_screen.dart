import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:yallabina/features/auth/log_in/login_view.dart';
import 'package:yallabina/features/exam/screens/FriendsListScreen.dart';
import 'package:yallabina/features/exam/screens/NotesScreen.dart';
import 'package:yallabina/features/exam/screens/chatbot.dart';
import 'package:yallabina/features/exam/screens/subjects/subjects_view.dart';
import 'package:yallabina/features/home/screens/MainScreen_controller.dart';
import 'package:yallabina/core/data/utils/shared_pref_utils.dart';
import 'package:yallabina/core/service/socket.dart';
import 'package:yallabina/core/theming/text_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainScreenController controller = Get.put(MainScreenController());
  String userName = "Loading...";
  String profileImage = '';
  int totalPoints = 0;
  final storage = FlutterSecureStorage();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    setState(() => isLoading = true);
    try {
      String? token = await storage.read(key: 'auth_token');
      print("Token fetched: $token");
      if (token == null) {
        setState(() {
          userName = "No token found";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://exammatchingapp-production.up.railway.app/api/student-profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = data['profile'];
        print("Profile data: $profile");

        setState(() {
          userName = profile['name'] ?? "Unknown";
          profileImage = profile['profilePic'] ?? 'assets/images/3d-cartoon-character (1).png';
          totalPoints = (profile['totalPoints'] ?? 0) as int;
          isLoading = false;
        });
      } else {
        setState(() {
          userName = "Error: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error fetching data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: ClipOval(
                      child: profileImage.startsWith('http')
                          ? Image.network(
                              profileImage,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            )
                          : Image.asset(
                              profileImage,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people, color: AppColors.primary),
              title: const Text('تنافس الآن', style: TextStyle(fontFamily: 'Cairo')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectsView()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: AppColors.primary),
              title: const Text('دردشة نصية', style: TextStyle(fontFamily: 'Cairo')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer, color: AppColors.primary),
              title: const Text('اسألني', style: TextStyle(fontFamily: 'Cairo')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('تسجيل الخروج', style: TextStyle(fontFamily: 'Cairo')),
              onTap: () async {
                final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();
                Get.defaultDialog(
                  titleStyle: TextStyles.font18DarkestNormal,
                  title: "Confirm Logout",
                  middleText: "Are you sure you want to logout?",
                  buttonColor: AppColors.darkestHeading,
                  contentPadding: const EdgeInsets.all(18),
                  textConfirm: "Yes",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    sharedPrefUtils.deleteUser();
                    SocketService.to.disconnect();
                    Get.delete<SocketService>();
                    Get.offAll(LoginView());
                  },
                  onCancel: () {},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: AppColors.primary),
              title: const Text('تواصل معنا', style: TextStyle(fontFamily: 'Cairo')),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("تواصل معنا"),
                    content: const Text("البريد الإلكتروني: support@yallabina.com\nواتساب: 0123456789"),
                    actions: [
                      TextButton(
                        child: const Text("حسناً"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GetBuilder<MainScreenController>(builder: (controller) {
              return Container(
                child: controller.tabs[controller.currentTab],
              );
            }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentTab,
        onTap: (index) => controller.changeTab(index: index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.text.withOpacity(0.6),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "تنافس"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "دردشة"),
          BottomNavigationBarItem(icon: Icon(Icons.face_3_rounded), label: "اسال AI"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
        ],
      ),
    );
  }
}