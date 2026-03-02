import 'package:equatable/equatable.dart';
import '../../../../data/models/group.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<Group> groups;
  const GroupLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GroupError extends GroupState {
  final String message;
  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupMembersLoaded extends GroupState {
  final List<String> memberIds;
  const GroupMembersLoaded(this.memberIds);

  @override
  List<Object?> get props => [memberIds];
}

class GroupCreated extends GroupState {}

class GroupMemberAdded extends GroupState {}

class GroupMemberError extends GroupState {
  final String message;
  const GroupMemberError(this.message);

  @override
  List<Object?> get props => [message];
}