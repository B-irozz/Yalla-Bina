class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String messageType;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isEdited;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.messageType,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isEdited = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? json['messageId'] ?? '',
      senderId: json['senderId'] is String ? json['senderId'] : json['senderId']['_id'],
      receiverId: json['receiverId'] is String ? json['receiverId'] : json['receiverId']['_id'],
      messageType: json['messageType'] ?? 'text',
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isEdited: json['updatedAt'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageType': messageType,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isEdited': isEdited,
    };
  }

  bool canEditOrDelete() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inMinutes <= 15;
  }
}