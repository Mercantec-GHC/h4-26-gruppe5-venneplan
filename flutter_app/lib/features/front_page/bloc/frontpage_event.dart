import 'package:equatable/equatable.dart';

abstract class FrontpageEvent extends Equatable {
  const FrontpageEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvent extends FrontpageEvent {
  final int eventId;

  const LoadEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class LoadFrontpage extends FrontpageEvent {
  final int userId;

  const LoadFrontpage(this.userId);

  @override
  List<Object?> get props => [userId];
}