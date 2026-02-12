// import '../../../domain/entities/chat_entity.dart';

class ChatData {
  final String? name;
  final List<int> participantCount;
  final String? message;
  final int chatId;

  const ChatData({
    required this.name,
    required this.participantCount,
    required this.message,
    required this.chatId,
  });
}

class ChatMessage {
  final DateTime sentAt;
  final int senderId;
  final int receiverId;
  final String? message;
  final int chatId;

  const ChatMessage({
    required this.sentAt,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.chatId,
  });
}

class GroupData {
  final String? name;

  const GroupData({required this.name});
}