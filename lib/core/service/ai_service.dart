// First, add these dependencies to your pubspec.yaml:
/*
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  dart_openai: ^5.1.0  # For OpenAI
  # OR
  dio: ^5.3.2  # Alternative HTTP client
*/

import 'dart:convert';
import 'package:http/http.dart' as http;

// ===========================================
// OPTION 1: OpenAI ChatGPT Integration
// ===========================================


// ===========================================
// OPTION 2: Anthropic Claude Integration
// ===========================================

class ClaudeService {
  static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY_HERE';
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 500,
          'messages': [
            {'role': 'user', 'content': message}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Claude Error: $e');
      return "Sorry, I'm having trouble connecting to the AI service.";
    }
  }
}

// ===========================================
// OPTION 3: Google Gemini Integration
// ===========================================

class GeminiService {
  static const String apiKey = 'AIzaSyCXDEIug5uLRAVK6wzY2ShUPseVhP84dvY';
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Gemini Error: $e');
      return "Sorry, I'm having trouble connecting to the AI service.";
    }
  }
}

// ===========================================
// OPTION 4: Local AI or Custom API
// ===========================================

class CustomAIService {
  static const String _baseUrl = 'YOUR_CUSTOM_API_ENDPOINT';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          // Add any required headers for your custom API
        },
        body: jsonEncode({
          'message': message,
          // Add other parameters your API expects
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response']; // Adjust based on your API response structure
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Custom AI Error: $e');
      return "Sorry, I'm having trouble connecting to the AI service.";
    }
  }
}

// ===========================================
// HOW TO USE IN YOUR CHAT SCREEN
// ===========================================

// Replace the _generateAIResponse method in your chat screen with:

Future<String> _generateAIResponse(String userMessage) async {
  try {
    // Choose one of these options:

    // Option 1: OpenAI
    //return await OpenAIService.sendMessageWithPackage(userMessage);

    // Option 2: Claude
    // return await ClaudeService.sendMessage(userMessage);

    // Option 3: Gemini
     return await GeminiService.sendMessage(userMessage);

    // Option 4: Custom API
    // return await CustomAIService.sendMessage(userMessage);

  } catch (e) {
    print('AI Response Error: $e');
    return "Sorry, I'm experiencing technical difficulties. Please try again.";
  }
}

// Also update your _sendMessage method to handle async:

// void _sendMessage() async {
//   if (_messageController.text.trim().isEmpty) return;
//
//   final userMessage = _messageController.text.trim();
//   _messageController.clear();
//
//   setState(() {
//     _messages.add(Message(
//       text: userMessage,
//       isUser: true,
//       timestamp: DateTime.now(),
//     ));
//     _isTyping = true;
//   });
//
//   _scrollToBottom();
//
//   try {
//     // Get AI response
//     final aiResponse = await _generateAIResponse(userMessage);
//
//     setState(() {
//       _messages.add(Message(
//         text: aiResponse,
//         isUser: false,
//         timestamp: DateTime.now(),
//       ));
//       _isTyping = false;
//     });
//   } catch (e) {
//     setState(() {
//       _messages.add(Message(
//         text: "Sorry, I encountered an error. Please try again.",
//         isUser: false,
//         timestamp: DateTime.now(),
//       ));
//       _isTyping = false;
//     });
//   }
//
//   _scrollToBottom();
// }