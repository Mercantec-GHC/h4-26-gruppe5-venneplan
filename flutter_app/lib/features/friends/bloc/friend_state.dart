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

/* --- ADD FRIEND STATES --- */

class FriendAdded extends FriendState {}

class FriendAddError extends FriendState {
  final String message;
  const FriendAddError(this.message);

  @override
  List<Object?> get props => [message];
}

/* --- USER SEARCH STATES --- */

class UsersLoaded extends FriendState {
  final List<Map<String, dynamic>> users;
  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class SearchResults extends FriendState {
  final List<Map<String, dynamic>> results;
  const SearchResults(this.results);

  @override
  List<Object?> get props => [results];
}