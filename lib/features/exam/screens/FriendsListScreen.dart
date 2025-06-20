import 'package:flutter/material.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:yallabina/features/exam/screens/ChatScreen.dart';
// import 'chat_contacts_screen.dart'; // استيراد صفحة الشات

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  // قائمة أصدقاء كمثال
  final List<Map<String, String>> friends = const [
    {"name": "أحمد علي", "image": "assets/images/3d-cartoon-character (1).png"},
    {"name": "محمد خالد", "image": "assets/images/3d-cartoon-character (1).png"},
    {"name": "سارة محمود", "image": "assets/images/3d-cartoon-character (1).png"},
    {"name": "علي حسن", "image": "assets/images/3d-cartoon-character (1).png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                // العنوان
                const Text(
                  "قائمة الأصدقاء",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),

                // قائمة الأصدقاء
                Expanded(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            // الانتقال لصفحة الشات مع بيانات الصديق
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  friendName: friends[index]["name"]!,
                                  friendImage: friends[index]["image"]!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.3),
                                  child: ClipOval(
                                    child: Image.asset(
                                      friends[index]["image"]!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  friends[index]["name"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
