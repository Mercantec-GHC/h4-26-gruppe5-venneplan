import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/frontpage_bloc.dart';
import '../bloc/frontpage_event.dart';
import '../bloc/frontpage_state.dart';
import '../widgets/event_list.dart';
import '../../events/view/Event_page.dart';
import '../../events/view/create_event_page.dart';

import '../../../data/repositories/event_repository_impl.dart';
import '../../../data/datasources/event_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class FrontpagePage extends StatelessWidget {
  final int userId;

  const FrontpagePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your events'),
      ),
      body: BlocProvider(
        create: (context) => FrontpageBloc(
          repository: EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSource(
              apiClient: ApiClient(),
            ),
          ),
        )..add(LoadFrontpage(userId)),
        child: BlocBuilder<FrontpageBloc, FrontpageState>(
          builder: (context, state) {
            if (state is FrontpageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FrontpageLoaded) {
              final events = state.events;
              
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Create Event'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CreateEventPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  if (events.isEmpty)
                    const Expanded(
                      child: Center(child: Text('No events found.')),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EventPage(eventId: event.id!),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              );
            } else if (state is FrontpageError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}