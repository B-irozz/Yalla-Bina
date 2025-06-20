import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService extends GetxService {
  WebSocketChannel? _channel;
  RxBool isConnected = false.obs;
  final _messagesController = StreamController<String>.broadcast();

  static SocketService get to => Get.find<SocketService>();

  Stream<String> get messages => _messagesController.stream;

  void connectAndVerify({
    required String token,
    required String serverUrl,
    required String email,
  }) {
    print('[SocketService] Connecting to WebSocket at $serverUrl');
    disconnect();

    try {
      final uri = Uri.parse(serverUrl);
      _channel = WebSocketChannel.connect(uri);
      print('[SocketService] Connected. Sending verify_login payload...');

      final loginPayload = {
        "type": "verify_login",
        "email": email,
        "token": token,
      };

      _channel!.sink.add(jsonEncode(loginPayload));
      isConnected.value = true;

      _channel!.stream.listen(
        (message) {
          print('[SocketService] Message from server: $message');
          _messagesController.add(message);
        },
        onError: (error) {
          print('[SocketService] WebSocket error: $error');
          isConnected.value = false;
          _messagesController.addError(error);
        },
        onDone: () {
          print('[SocketService] WebSocket connection closed');
          isConnected.value = false;
          _messagesController.close();
        },
      );
    } catch (e) {
      print('[SocketService] Failed to connect: $e');
      isConnected.value = false;
      _messagesController.addError(e);
    }
  }

  void sendMatchRequest({
  required String email,
  required String subjectId,
  required String preferredGenderId,
  required String gradeLevelId,
  required int scientificTrackId, // ✅ النوع الصحيح int بدل String?
  required int totalPoints,       // ✅ أضفنا totalPoints
}) {
  if (_channel == null || !isConnected.value) {
    print('[SocketService] Cannot send match request: Not connected');
    return;
  }

  final matchPayload = {
    "type": "match_request",
    "email": email,
    "subjectId": subjectId,
    "preferred_gender_id": preferredGenderId,
    "gradeLevelId": gradeLevelId,
    "scientificTrackId": scientificTrackId,
    "totalPoints": totalPoints, 
  };

  print('[SocketService] Sending match_request payload: $matchPayload');
  _channel!.sink.add(jsonEncode(matchPayload));
}

  void submitAnswers({
    required String examId,
    required int studentId,
    required String email,
    required List<Map<String, String>> answers,
  }) {
    if (_channel == null || !isConnected.value) {
      print('[SocketService] Cannot submit answers: Not connected');
      return;
    }

    final submitPayload = {
      "type": "submit_answers",
      "examId": examId,
      "studentId": studentId,
      "email": email,
      "answers": answers,
    };

    print('[SocketService] Sending submit_answers payload: $submitPayload');
    _channel!.sink.add(jsonEncode(submitPayload));
  }

  void disconnect() {
    if (_channel != null) {
      print('[SocketService] Closing WebSocket...');
      _channel!.sink.close();
      _channel = null;
      isConnected.value = false;
      _messagesController.close();
    } else {
      print('[SocketService] No active WebSocket to disconnect');
    }
  }

  @override
  void onClose() {
    disconnect();
    _messagesController.close();
    super.onClose();
  }

  bool get connected => isConnected.value;

  WebSocketChannel? get channel => _channel;
}