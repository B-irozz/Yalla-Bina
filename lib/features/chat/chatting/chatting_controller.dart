import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yallabina/core/data/repos/chat/chat_messages_repo.dart';
import '../../../core/service/chat_socket_service.dart';
import 'message_model.dart';

class ChatController extends GetxController {
  final ChatSocketService socketService = ChatSocketService();
  final String receiverId;
  final String receiverName;
  final String currentUserId;
  final ChatMessages chatRepo = Get.put(ChatMessages());

  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isConnected = false.obs;
  var displayedMessageIds = <String>{}.obs;

  ChatController({
    required this.receiverId,
    required this.receiverName,
    required this.currentUserId,
  });

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
    loadPreviousMessages();
  }

  void _initializeSocket() {
    socketService.init(currentUserId, receiverId: receiverId);

    // Handle socket connection status
    socketService.socket.onConnect((_) {
      isConnected.value = true;
      print('Socket connected');
    });

    socketService.socket.onDisconnect((_) {
      isConnected.value = false;
      print('Socket disconnected');
    });

    // Handle incoming messages
    socketService.socket.on('receiveMessage', (data) {
      print('Received message: $data');
      _handleIncomingMessage(data);
    });

    // Handle message updates
    socketService.socket.on('messageUpdated', (data) {
      print('Message updated: $data');
      _handleMessageUpdate(data);
    });

    // Handle message deletions
    socketService.socket.on('messageDeleted', (data) {
      print('Message deleted: $data');
      _handleMessageDeletion(data);
    });
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      final message = Message.fromJson(data);
      if (!displayedMessageIds.contains(message.id)) {
        _addOrUpdateMessage(message);
        displayedMessageIds.add(message.id);

        // Optionally send read receipt
        if (message.senderId != currentUserId) {
          socketService.socket.emit('messageRead', {
            'messageId': message.id,
            'senderId': message.senderId
          });
        }
      }
    } catch (e) {
      print('Error handling incoming message: $e');
    }
  }

  void _handleMessageUpdate(dynamic data) {
    try {
      final updatedMessage = Message.fromJson(data);
      _addOrUpdateMessage(updatedMessage);
    } catch (e) {
      print('Error handling message update: $e');
    }
  }

  void _handleMessageDeletion(dynamic data) {
    try {
      final messageId = data['messageId'];
      messages.removeWhere((m) => m.id == messageId);
      displayedMessageIds.remove(messageId);
    } catch (e) {
      print('Error handling message deletion: $e');
    }
  }

  void _addOrUpdateMessage(Message message) {
    final index = messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      messages[index] = message;
    } else {
      messages.add(message);
    }
    // Sort by timestamp (oldest first)
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> loadPreviousMessages() async {
    isLoading(true);
    try {
      final result = await chatRepo.getMessages(receiverId);

      result.fold(
        (failure) {
          // Handle failure case
          Get.snackbar('Error', failure.errorMessage);
        },
        (response) {
          // Update messages list with new messages
          final newMessages = response.result.where((msg) => !displayedMessageIds.contains(msg.id)).toList();

          if (newMessages.isNotEmpty) {
            messages.insertAll(0, newMessages);
            displayedMessageIds.addAll(newMessages.map((m) => m.id));
            messages.refresh();
          }
        },
      );
    } catch (e) {
      print('Error loading previous messages: $e');
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading(false);
    }
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final message = {
      'senderId': currentUserId,
      'receiverId': receiverId,
      'messageType': 'text',
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
    };

    socketService.socket.emitWithAck('sendMessage', message, ack: (response) {
      if (response != null && response['_id'] != null) {
        final sentMessage = Message.fromJson(response);
        _addOrUpdateMessage(sentMessage);
        displayedMessageIds.add(sentMessage.id);
      }
    });
  }

  void updateMessage(String messageId, String newContent) {
    if (newContent.trim().isEmpty) return;

    socketService.socket.emitWithAck('updateMessage', {'messageId': messageId, 'newContent': newContent}, ack: (response) {
      if (response != null && response['_id'] != null) {
        final updatedMessage = Message.fromJson(response);
        _addOrUpdateMessage(updatedMessage);
      }
    });
  }

  void deleteMessage(String messageId) {
    socketService.socket.emitWithAck('deleteMessage', messageId, ack: (response) {
      if (response != null && response['success'] == true) {
        messages.removeWhere((m) => m.id == messageId);
        displayedMessageIds.remove(messageId);
      }
    });
  }

  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  void onClose() {
    socketService.socket.off('receiveMessage');
    socketService.socket.off('messageUpdated');
    socketService.socket.off('messageDeleted');
    socketService.dispose();
    super.onClose();
  }
}