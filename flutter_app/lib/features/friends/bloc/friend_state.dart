import 'package:equatable/equatable.dart';
import '../../../data/models/friend.dart';

abstract class FriendState extends Equatable {
  const FriendState();

  @override
  List<Object?> get props => [];
}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<Friend> friends;
  const FriendLoaded(this.friends);

  @override
  List<Object?> get props => [friends];
}

class FriendError extends FriendState {
  final String message;
  const FriendError(this.message);

  @override
  List<Object?> get props => [message];
}

class FriendAdded extends FriendState {}

class FriendAddError extends FriendState {
  final String message;
  const FriendAddError(this.message);

  @override
  List<Object?> get props => [message];
}