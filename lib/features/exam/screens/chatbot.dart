import 'package:flutter/material.dart';
import 'package:yallabina/core/constant/colors.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {
      "text": "مرحبًا! أنا بوت يلا بينا، إزاي أساعدك النهاردة؟",
      "sender": "bot"
    },
  ];

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        // إضافة رسالة المستخدم
        messages.add({"text": _messageController.text, "sender": "user"});

        // رد تلقائي من البوت (مثال بسيط)
        String userMessage = _messageController.text.toLowerCase();
        String botResponse;
        if (userMessage.contains("مرحبا") || userMessage.contains("اهلا")) {
          botResponse = "أهلاً بيك! إيه اللي في بالك؟";
        } else if (userMessage.contains("ازيك")) {
          botResponse = "أنا كويس، شكرًا! وأنت؟";
        } else if (userMessage.contains("امتحان")) {
          botResponse =
              "عايز تعرف عن الامتحانات؟ اختار رقم من 1 لـ 5 وأنا أساعدك!";
        } else {
          botResponse = "مش فاهمك بالظبط، ممكن توضح أكتر؟";
        }
        messages.add({"text": botResponse, "sender": "bot"});

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
              // رأس الصفحة
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
                          'assets/images/3d-cartoon-character (1).png', // صورة افتراضية للبوت
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "يلا بينا بوت",
                      style: TextStyle(
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
                    bool isBot = messages[index]["sender"] == "bot";
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment: isBot
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isBot
                                ? Colors.white.withOpacity(0.8)
                                : AppColors.primary.withOpacity(0.8),
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
                              color: isBot ? AppColors.text : Colors.white,
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
                            hintText: "اكتب سؤالك هنا...",
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
