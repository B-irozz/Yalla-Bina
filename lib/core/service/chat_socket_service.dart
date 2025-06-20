import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  static final ChatSocketService _instance = ChatSocketService._internal();
  late IO.Socket socket;
  String? userId;
  String? currentChatRoom;

  factory ChatSocketService() {
    return _instance;
  }

  ChatSocketService._internal();

  void init(String userId, {String? receiverId}) {
    this.userId = userId;
    socket = IO.io('https://authchatapp-production.up.railway.app', <String, dynamic>{
      'transports': ['websocket'],
      'query': {'userId': userId},
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Connected to socket server');
      if (receiverId != null) {
        joinChatRoom(userId, receiverId);
      }
    });

    socket.onDisconnect((_) => print('Disconnected from socket server'));
    socket.onError((error) => print('Socket error: $error'));
    socket.connect();
  }

  void joinChatRoom(String senderId, String receiverId) {
    currentChatRoom = 'chat_${senderId}_$receiverId';
    socket.emit('join', currentChatRoom);
    print('Joined room: $currentChatRoom');
  }

  void sendMessage(Map<String, dynamic> message, {Function(dynamic)? ack}) {
    socket.emitWithAck('sendMessage', message, ack: ack);
  }

  void updateMessage(String messageId, String newContent, {Function(dynamic)? ack}) {
    socket.emitWithAck('updateMessage', {'messageId': messageId, 'newContent': newContent}, ack: ack);
  }

  void deleteMessage(String messageId, {Function(dynamic)? ack}) {
    socket.emitWithAck('deleteMessage', messageId, ack: ack);
  }

  void onReceiveMessage(Function(dynamic) callback) {
    socket.on('receiveMessage', callback);
  }

  void onMessageUpdated(Function(dynamic) callback) {
    socket.on('messageUpdated', callback);
  }

  void onMessageDeleted(Function(dynamic) callback) {
    socket.on('messageDeleted', callback);
  }

  void dispose() {
    socket.off('receiveMessage');
    socket.off('messageUpdated');
    socket.off('messageDeleted');
    socket.dispose();
  }
}