import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_state.dart';

import '../../../../data/repositories/user_repository_impl.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await repository.fetchUserNames();
        result.when(
          success: (users) => emit(UserLoaded(users)),
          failure: (error) => emit(UserError(error.message)),
        );
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
