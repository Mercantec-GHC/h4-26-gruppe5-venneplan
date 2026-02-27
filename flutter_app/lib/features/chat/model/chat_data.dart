// import '../../../domain/entities/chat_entity.dart';

class ChatData {
  final String? name;
  final List<int> participantCount;
  final String? content;
  final int chatId;

  const ChatData({
    required this.name,
    required this.participantCount,
    required this.content,
    required this.chatId,
  });
}

class ChatMessage {
  final DateTime sentAt;
  final int senderId;
  final int receiverId;
  final String? content;
  final int chatId;

  const ChatMessage({
    required this.sentAt,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.chatId,
  });
}

class GroupData {
  final String? name;

  const GroupData({required this.name});
}