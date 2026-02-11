import 'package:flutter/material.dart';
import '../../../domain/entities/chat_entity.dart';
// import '../model/chat_data.dart';

class ChatCard extends StatelessWidget {
  final ChatEntity chat;
  final GroupEntity group;

  const ChatCard({super.key, required this.chat, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(chat.name ?? 'No Name'), // Chat name
            subtitle: Text(chat.message ?? 'No Message'), // Latest message preview
          ),
          ListTile(
