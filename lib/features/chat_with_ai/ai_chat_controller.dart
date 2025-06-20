import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/service/ai_service.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AIChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<Message> messages = <Message>[].obs;
  final RxBool isTyping = false.obs;

  late AnimationController typingAnimationController;
  late List<AnimationController> dotAnimationControllers;
  late List<Animation<double>> dotAnimations;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _addWelcomeMessage();
  }

  void _initializeAnimations() {
    typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    dotAnimationControllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    dotAnimations = dotAnimationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  void _addWelcomeMessage() {
    messages.add(Message(
      text: "مرحباً! أنا مساعدك الذكي. كيف يمكنني مساعدتك اليوم؟",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final userMessage = messageController.text.trim();
    messageController.clear();

    // Add user message
    messages.add(Message(
      text: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Start typing animation
    isTyping.value = true;
    _startTypingAnimation();

    scrollToBottom();

    try {
      // Get AI response
      final response = await generateAIResponse(userMessage);

      // Add AI response
      messages.add(Message(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      // Handle error
      messages.add(Message(
        text: "عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      // Stop typing animation
      isTyping.value = false;
      _stopTypingAnimation();
      scrollToBottom();
    }
  }

  Future<String> generateAIResponse(String userMessage) async {
    try {
      final response = await GeminiService.sendMessage(userMessage);
      return response;
    } catch (e) {
      throw Exception('Failed to get AI response');
    }
  }

  void _startTypingAnimation() {
    typingAnimationController.repeat();

    for (int i = 0; i < dotAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (isTyping.value) {
          dotAnimationControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopTypingAnimation() {
    typingAnimationController.stop();
    for (var controller in dotAnimationControllers) {
      controller.stop();
      controller.reset();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    typingAnimationController.dispose();
    for (var controller in dotAnimationControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}