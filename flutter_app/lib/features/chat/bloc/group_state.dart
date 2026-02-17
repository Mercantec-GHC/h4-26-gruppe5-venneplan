import 'package:equatable/equatable.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<String> groupNames;
  const GroupLoaded(this.groupNames);

  @override
  List<Object?> get props => [groupNames];
}

class GroupError extends GroupState {
  final String message;
  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupMembersLoaded extends GroupState {
  final List<int> memberIds;
  const GroupMembersLoaded(this.memberIds);

  @override
  List<Object?> get props => [memberIds];
}

class GroupCreated extends GroupState {}