import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../model/create_event_data.dart';
import '../../../core/di/injection.dart';
import 'Event_page.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // TODO: Replace with authenticated user id when auth is available.
  static const int _tempUserId = 1;
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _createEvent(BuildContext blocContext) {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final eventData = CreateEventData(
      title: _titleController.text,
      adress: _locationController.text,
      date: _selectedDateTime!,
      description: _descriptionController.text,
      hostId: _tempUserId,
    );

    blocContext.read<EventBloc>().add(CreateEvent(eventData));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Event')),
        body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventLoaded) {
            if (state.event.id != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event created successfully!')),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EventPage(eventId: state.event.id!),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event created but ID is null')),
              );
            }
          } else if (state is EventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is EventLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          picker.DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            onConfirm: (date) {
                              setState(() {
                                _selectedDateTime = date.toUtc();
                              });
                            },
                            locale: picker.LocaleType.da,
                          );
                        },
                  child: Text(
                    _selectedDateTime == null
                        ? 'vælg tid og dato'
                        : 'Tid: ${_selectedDateTime!.toLocal()}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : () => _createEvent(context),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Event'),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}
