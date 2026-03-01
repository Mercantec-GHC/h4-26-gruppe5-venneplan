import 'package:equatable/equatable.dart';

abstract class FriendEvent extends Equatable {
  const FriendEvent();

  @override
  List<Object?> get props => [];
}

class LoadFriends extends FriendEvent {
  final int userId;
  const LoadFriends(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddFriend extends FriendEvent {
  final int currentUserId;
  final int friendId;
  const AddFriend(this.currentUserId, this.friendId);

  @override
  List<Object?> get props => [currentUserId, friendId];
}

class LoadAllUsers extends FriendEvent {}

class SearchUsers extends FriendEvent {
  final String query;
  const SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends FriendEvent {}