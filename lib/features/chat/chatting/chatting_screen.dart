import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatting_controller.dart';
import 'message_model.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String currentUserId;

  ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.currentUserId,
  });

  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(
        receiverId: receiverId,
        receiverName: receiverName,
        currentUserId: currentUserId,
      ),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(receiverName),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.loadPreviousMessages,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages.reversed.toList()[index];
                      final isMe = message.senderId == currentUserId;

                      return GestureDetector(
                        onLongPress: () {
                          if (isMe && message.canEditOrDelete()) {
                            _showMessageOptions(context, controller, message);
                          }
                        },
                        child: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Row(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     if (message.isEdited)
                                //       Padding(
                                //         padding: const EdgeInsets.only(right: 4),
                                //         child: Text(
                                //           'edited',
                                //           style: TextStyle(
                                //             color: isMe ? Colors.white70 : Colors.black54,
                                //             fontSize: 10,
                                //             fontStyle: FontStyle.italic,
                                //           ),
                                //         ),
                                //       ),
                                //     Text(
                                //       controller.formatTime(message.createdAt),
                                //       style: TextStyle(
                                //         color: isMe ? Colors.white70 : Colors.black54,
                                //         fontSize: 10,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        focusNode: messageFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: (_) => _sendMessage(controller),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage(ChatController controller) {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      controller.sendMessage(message);
      messageController.clear();
      messageFocusNode.requestFocus();
    }
  }

  void _showMessageOptions(
      BuildContext context, ChatController controller, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Message'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context, controller, message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Message'),
              onTap: () {
                Navigator.pop(context);
                controller.deleteMessage(message.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      BuildContext context, ChatController controller, Message message) {
    final editController = TextEditingController(text: message.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: editController,
            autofocus: true,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Edit your message...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newContent = editController.text.trim();
                if (newContent.isNotEmpty && newContent != message.content) {
                  controller.updateMessage(message.id, newContent);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}