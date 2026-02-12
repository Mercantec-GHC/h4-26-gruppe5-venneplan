import 'package:equatable/equatable.dart';

abstract class ChatMessageEntity extends Equatable {
  final DateTime sentAt;
  final int senderId;
  final int receiverId;
  final String? message;
  final int chatId;

  const ChatMessageEntity({
    required this.sentAt,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.chatId,
  });
}

abstract class ChatEntity extends Equatable {
  final String? name;
  final List<int> participantCount;
  final String? message;
  final int chatId;

  const ChatEntity({
    required this.name,
    required this.participantCount,
    required this.message,
    required this.chatId,
  });
}

abstract class GroupEntity extends Equatable {
  final String? name;

  const GroupEntity({required this.name});
}