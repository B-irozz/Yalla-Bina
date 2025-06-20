import 'package:flutter/material.dart';
import 'package:yallabina/core/constant/colors.dart';

class ChatScreen extends StatefulWidget {
  final String friendName;
  final String friendImage;

  const ChatScreen(
      {super.key, required this.friendName, required this.friendImage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {"text": "مرحبًا! إزيك؟", "sender": "friend"},
    {"text": "أنا كويس، وأنت؟", "sender": "me"},
  ];

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({"text": _messageController.text, "sender": "me"});
        _messageController.clear();
      });
    }
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
              AppColors.primary.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // رأس الصفحة (صورة واسم الصديق)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.text),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primary.withOpacity(0.3),
                      child: ClipOval(
                        child: Image.asset(
                          widget.friendImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      widget.friendName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              // قائمة الرسائل
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isMe = messages[index]["sender"] == "me";
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primary.withOpacity(0.8)
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            messages[index]["text"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMe ? Colors.white : AppColors.text,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // حقل إرسال الرسالة
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "اكتب رسالتك...",
                            hintStyle: const TextStyle(
                                color: AppColors.text, fontFamily: 'Cairo'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
