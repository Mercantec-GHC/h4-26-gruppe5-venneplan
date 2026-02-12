import 'package:flutter/material.dart';
import '../../../domain/entities/chat_entity.dart';

class ChatCard extends StatelessWidget {
  final ChatEntity chat;

  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(chat.name ?? 'No Name'), // Chat name
        subtitle: Text(chat.message ?? 'No Message'), // Latest message preview
        trailing: Text('Participants: ${chat.participantCount.length}'), // Participant count
      ),
    );
  }
}