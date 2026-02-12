import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroups extends GroupEvent {}

class LoadGroupMembers extends GroupEvent {
  final int groupId;
  const LoadGroupMembers(this.groupId);

  @override
  List<Object?> get props => [groupId];
}