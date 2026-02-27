import 'package:equatable/equatable.dart';

import '../model/create_event_data.dart';
abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvent extends EventEvent {
  final int eventId;

  const LoadEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class CreateEvent extends EventEvent {
  final CreateEventData eventCreateData;

  const CreateEvent(this.eventCreateData);

  @override
  List<Object?> get props => [eventCreateData];
}

class UpdateParticipantStatus extends EventEvent {
  final int userId;
  final bool isGoing;

  const UpdateParticipantStatus({
    required this.userId,
    required this.isGoing,
  });

  @override
  List<Object?> get props => [userId, isGoing];
}