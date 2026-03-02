import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_event.dart';
import 'group_state.dart';
import '../../../data/repositories/group_repository_impl.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepositoryImpl repository;

  GroupBloc({required this.repository}) : super(GroupInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());
      try {
        final result = await repository.fetchGroups();
        result.when(
          success: (groups) => emit(GroupLoaded(groups)),
          failure: (error) => emit(GroupError(error.message)),
        );
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });

    on<LoadGroupMembers>((event, emit) async {
      emit(GroupLoading());
      try {
        final result = await repository.fetchGroupMembers(event.groupId);
        result.when(
          success: (members) =>emit(GroupMembersLoaded(members)),
          failure: (error) => emit(GroupError(error.message)),
        );
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });

    on<AddGroupMember>((event, emit) async {
      try {
        final result = await repository.addGroupMember(event.groupId, event.userId);
        result.when(
          success: (_) => emit(GroupMemberAdded()),
          failure: (error) => emit(GroupMemberError(error.message)),
        );
      } catch (e) {
        emit(GroupMemberError(e.toString()));
      }
    });

    on<CreateGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        final result = await repository.createGroup(event.name);
        result.when(
          success: (_) => emit(GroupCreated()),
          failure: (error) => emit(GroupError(error.message)),
        );
      } catch (e) {
        emit(GroupError(e.toString()));
      }
    });
  }
}
