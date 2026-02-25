import 'package:bloc/bloc.dart';
import '../../../domain/repositories/event_repository.dart';
import '../model/event_data.dart';

import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository repository;

  EventBloc({required this.repository}) : super(EventInitial()) {
    on<LoadEvent>(_onLoadEvent);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateParticipantStatus>(_onUpdateParticipantStatus);
  }

  Future<void> _onLoadEvent(
    LoadEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await repository.fetchEvent(event.eventId);
    result.when(
      success: (data) => emit(EventLoaded(data)),
      failure: (error) => emit(EventError(error.userMessage)),
    );
  }

  Future<void> _onCreateEvent(
    CreateEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await repository.createEvent(event.eventCreateData);
    result.when(
      success: (data) => emit(EventLoaded(data)),
      failure: (error) => emit(EventError(error.userMessage)),
    );
  }

  Future<void> _onUpdateParticipantStatus(
    UpdateParticipantStatus event,
    Emitter<EventState> emit,
  ) async {
    final currentEvent = _extractEvent(state);
    if (currentEvent == null || currentEvent.id == null) {
      emit(const EventError('Event not loaded.'));
      return;
    }

    emit(EventLoading());

    final result = await repository.updateParticipantStatus(
      eventId: currentEvent.id!,
      userId: event.userId,
      isGoing: event.isGoing,
    );

    if (result.isSuccess) {
      final refreshResult = await repository.fetchEvent(currentEvent.id!);
      refreshResult.when(
        success: (updatedEvent) => emit(EventLoaded(updatedEvent)),
        failure: (error) => emit(EventError(error.userMessage)),
      );
    } else {
      emit(EventError(result.exceptionOrNull?.userMessage ?? 'Unknown error'));
    }
  }

  static EventData? _extractEvent(EventState state) {
    return switch (state) {
      EventLoaded() => state.event,
      _ => null,
    };
  }
}
