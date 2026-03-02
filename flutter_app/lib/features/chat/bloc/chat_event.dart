import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatData extends ChatEvent {
  const LoadChatData();
}

class RefreshChatData extends ChatEvent {
  const RefreshChatData();
}

