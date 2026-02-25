import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/events/model/event_data.dart';

abstract class FrontpageState extends Equatable {
  const FrontpageState();

  @override
  List<Object?> get props => [];
}

class FrontpageInitial extends FrontpageState {}

class FrontpageLoading extends FrontpageState {}

class FrontpageLoaded extends FrontpageState {
  final List<EventData> events;

  const FrontpageLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class FrontpageError extends FrontpageState {
  final String message;

  const FrontpageError(this.message);

  @override
  List<Object?> get props => [message];
}