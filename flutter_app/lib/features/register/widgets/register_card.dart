import 'package:flutter/material.dart';

class RegisterCard extends StatelessWidget {
  final String title;
  final String description;

  const RegisterCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
