import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constant/colors.dart';
import '../../exam/screens/FriendsListScreen.dart';
import '../../exam/screens/chatbot.dart';
import '../../exam/screens/subjects/subjects_view.dart';
import 'home_screen_controller.dart';
import 'MainScreen_controller.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final HomeController controller = Get.put(HomeController());
  final MainScreenController mainController = Get.find<MainScreenController>();
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
    if (!mounted) return; // التحقق من mounted
    setState(() => isLoading = true);
    try {
      String? token = await storage.read(key: 'auth_token');
      print("Token fetched: $token");
      if (token == null) {
        if (mounted) {
          setState(() {
            userName = "No token found";
            isLoading = false;
          });
        }
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

        if (mounted) {
          setState(() {
            userName = profile['name'] ?? "Unknown";
            profileImage = profile['profilePic'] ?? 'assets/images/3d-cartoon-character (1).png';
            totalPoints = (profile['totalPoints'] ?? 0) as int;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            userName = "Error: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = "Error fetching data: $e";
          isLoading = false;
        });
      }
      print("Error fetching profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : GetBuilder<HomeController>(
            builder: (controller) {
              return Container(
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
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                const SizedBox(width: 10),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.search, color: AppColors.primary),
                                    onPressed: () => controller.showCodeDialog(context),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Builder(
                                    builder: (context) => IconButton(
                                      icon: const Icon(Icons.menu, color: AppColors.primary),
                                      onPressed: () => Scaffold.of(context).openDrawer(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                buildFeatureCard(
                                  title: "تنافس الآن",
                                  icon: Icons.people,
                                  gradientColors: [AppColors.primary, AppColors.secondary],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SubjectsView()),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                buildFeatureCard(
                                  title: "دردشة نصية",
                                  icon: Icons.chat,
                                  gradientColors: [AppColors.secondary, AppColors.accent],
                                  onTap: () {
                                    mainController.changeTab(index: 2);
                                  },
                                ),
                                const SizedBox(height: 20),
                                buildFeatureCard(
                                  title: "اسألني",
                                  icon: Icons.question_answer,
                                  gradientColors: [AppColors.accent, AppColors.secondary],
                                  onTap: () {
                                    mainController.changeTab(index: 3);
                                  },
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.primary, AppColors.secondary],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "مستواك العام",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            height: 120,
                                            width: 120,
                                            child: CircularProgressIndicator(
                                              value: totalPoints / 4000,
                                              strokeWidth: 10,
                                              backgroundColor: Colors.white.withOpacity(0.3),
                                              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                                            ),
                                          ),
                                          Text(
                                            "${(totalPoints / 4000 * 100).toStringAsFixed(0)}%",
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget buildFeatureCard({
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
            ),
            Icon(icon, size: 30, color: Colors.white.withOpacity(0.9)),
          ],
        ),
      ),
    );
  }
}