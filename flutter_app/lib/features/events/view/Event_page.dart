import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/models/event_data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  EventData _event = new EventData();
  bool _isLoading = false;
  final String baseUrl = 'http://localhost:5197';

  @override
  void initState() {
    super.initState();
    GetEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_event.title == null || _event.title!.isEmpty)
            const Text(
              'Event Title',  
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          else
            Text(
              _event.title!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 12),

         if (_event.description == null || _event.description!.isEmpty)
            const Text(
              'Event Description',
            )
          else
            Text(
              _event.description!,
            ),
          const SizedBox(height: 12),

          if (_event.adress == null || _event.adress!.isEmpty)
            const Text(
              'Event Location',
            )
          else
            Text(
              _event.adress!,
            ),
          const SizedBox(height: 12),

          Text(formatDate(_event.date)),
          Text('participants: ${_event.participantCount?.toString() ?? 'participant count'}'),
        ],
      ),
    );
  }

  Future<void> GetEvent() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/event/3'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        setState(() {
          _event = EventData.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading events: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'date time';
    return DateFormat.yMMMd().add_jm().format(date);
  }
}
