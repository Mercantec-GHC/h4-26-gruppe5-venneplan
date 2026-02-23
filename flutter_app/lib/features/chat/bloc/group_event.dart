import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}


class LoadGroups extends GroupEvent {}

class AddGroupMember extends GroupEvent {
  final int groupId;
  final int userId;
  const AddGroupMember(this.groupId, this.userId);

  @override
  List<Object?> get props => [groupId, userId];
}

class LoadGroupMembers extends GroupEvent {
  final int groupId;
  const LoadGroupMembers(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class CreateGroup extends GroupEvent {
  final String name;
  const CreateGroup(this.name);

  @override
  List<Object?> get props => [name];
}