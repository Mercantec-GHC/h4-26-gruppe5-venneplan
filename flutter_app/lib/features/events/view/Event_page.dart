import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/events/bloc/event_bloc.dart';
import 'package:flutter_app/features/events/bloc/event_event.dart';
import 'package:flutter_app/features/events/bloc/event_state.dart';
import 'package:flutter_app/core/di/injection.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key, required this.eventId});

  final int eventId;
  // TODO: Replace with authenticated user id when auth is available.
  static const int _tempUserId = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventBloc>()..add(LoadEvent(eventId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EventError) {
              return Center(child: Text(state.message));
            }

            if (state is EventLoaded) {
              final event = state.event;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    getPlaceholder('', event.title, 'Event Title'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    getPlaceholder('Description: ', event.description, 'Event Description'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    getPlaceholder('Location: ', event.adress, 'Event Location'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    formatDate(event.date),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'participants: ${event.participantCount?.toString() ?? 'participant count'}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            elevation: 4,
                          ),      
                          onPressed: () {
                            context.read<EventBloc>().add(
                                  const UpdateParticipantStatus(
                                    userId: _tempUserId,
                                    isGoing: true,
                                  ),
                                );
                          },
                          child: const Text('Accept'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            elevation: 2,
                          ),
                          onPressed: () {
                            context.read<EventBloc>().add(
                                  const UpdateParticipantStatus(
                                    userId: _tempUserId,
                                    isGoing: false,
                                  ),
                                );
                          },
                          child: const Text('Decline'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'date time';
    return DateFormat.yMMMd().add_jm().format(date);
  }

  /// Returns [placeholder] if [value] is null or empty
  String getPlaceholder(String? pretext, String? value, String placeholder) {
    if (value == null || value.trim().isEmpty) return placeholder;
    return (pretext ?? '') + value;
  }
}
