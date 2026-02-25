import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final String name;

  const FriendCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
      ),
    );
  }
}