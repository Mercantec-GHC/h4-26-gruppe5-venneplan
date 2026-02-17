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
        final result = await repository.fetchGroupNames();
        result.when(
          success: (groupNames) => emit(GroupLoaded(groupNames)),
          failure: (error) => emit(GroupError(error.message)),
        );
      } catch (e) {
        emit(GroupError(e.toString()));
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
