import 'package:equatable/equatable.dart';

abstract class FriendEvent extends Equatable {
  const FriendEvent();

  @override
  List<Object?> get props => [];
}

class LoadFriends extends FriendEvent {}

class AddFriend extends FriendEvent {
  final int userId;
  const AddFriend(this.userId);

  @override
  List<Object?> get props => [userId];
}