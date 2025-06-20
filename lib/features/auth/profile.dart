import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // عدّل الاستيراد
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String profileImage = '';
  int totalPoints = 0;
  int ranking = 0;
  String studentCode = "Loading...";

  final storage = FlutterSecureStorage(); // عدّل إلى الاسم الصحيح
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
  setState(() => isLoading = true);
  try {
    String? token = await storage.read(key: 'auth_token'); // قراءة من FlutterSecureStorage
    print("Token fetched: $token"); // للتأكد
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
      print("Profile image URL: $profileImage");

      setState(() {
        userName = profile['name'] ?? "Unknown";
        profileImage = profile['profilePic'] ?? 'assets/images/3d-cartoon-character (1).png';
        totalPoints = (profile['totalPoints'] ?? 0) as int;
        ranking = (profile['rank'] ?? 0) as int;
        studentCode = profile['studentId'].toString();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.logout, color: AppColors.primary),
                          tooltip: "تسجيل الخروج",
                          onPressed: () async {
                            await storage.delete(key: 'auth_token');
                            if (mounted) {
                              setState(() => userName = "Logged out");
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تسجيل الخروج")));
                              Navigator.of(context).pushNamedAndRemoveUntil('/LoginScreen', (Route<dynamic> route) => false);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                        radius: 70,
                        backgroundColor: AppColors.primary.withOpacity(0.3),
                        child: ClipOval(
                          child: profileImage.startsWith('http')
                              ? Image.network(
                                  profileImage,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                                )
                              : profileImage.startsWith('/data')
                                  ? Image.file(
                                      File(profileImage),
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                                    )
                                  : Image.asset(
                                      profileImage,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                                    ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildStatCard(
                          title: "النقاط",
                          value: totalPoints.toString(),
                          icon: Icons.star,
                          gradientColors: [AppColors.primary, AppColors.secondary],
                        ),
                        buildStatCard(
                          title: "الترتيب",
                          value: "#$ranking",
                          icon: Icons.leaderboard,
                          gradientColors: [AppColors.secondary, AppColors.accent],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: studentCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("📋 تم نسخ كود الطالب")),
                          );
                        },
                        child: buildStatCard(
                          title: "كود الطالب (اضغط للنسخ)",
                          value: studentCode,
                          icon: Icons.badge,
                          gradientColors: [AppColors.accent, AppColors.primary],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}