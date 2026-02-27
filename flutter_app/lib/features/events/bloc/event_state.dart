import 'package:equatable/equatable.dart';

import 'package:flutter_app/features/events/model/event_data.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final EventData event;

  const EventLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}