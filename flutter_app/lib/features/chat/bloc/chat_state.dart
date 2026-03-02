import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_entity.dart';
import '../model/chat_data.dart';

/// Base class for alle Chat states
/// 
/// Bruger Equatable for automatisk equality comparison.
/// Dette gør at BLoC kun rebuilder widgets når state faktisk ændrer sig.
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chatData;
  final ChatData chatModel;

  const ChatLoaded({
    required this.chatData,
    required this.chatModel,
  });

  @override
  List<Object?> get props => [chatData, chatModel];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}