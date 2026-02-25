import 'package:flutter/material.dart';
import '../../events/model/event_data.dart';

class EventCard extends StatelessWidget {
  final EventData event;
  final VoidCallback? onTap;

  const EventCard({
    super.key, 
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = (event.title?.isNotEmpty ?? false) 
        ? event.title! 
        : 'Untitled event';
    
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          (event.description?.isNotEmpty ?? false)
              ? event.description!
              : 'No description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}