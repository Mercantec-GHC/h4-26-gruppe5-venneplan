import 'package:flutter_bloc/flutter_bloc.dart';
import 'friend_event.dart';
import 'friend_state.dart';
import '../../../data/repositories/friend_repository_impl.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepositoryImpl repository;

  FriendBloc({required this.repository}) : super(FriendInitial()) {
    on<LoadFriends>((event, emit) async {
      emit(FriendLoading());
      try {
        final result = await repository.fetchFriends();
        result.when(
          success: (friends) => emit(FriendLoaded(friends)),
          failure: (error) => emit(FriendError(error.message)),
        );
      } catch (e) {
        emit(FriendError(e.toString()));
      }
    });

    on<AddFriend>((event, emit) async {
      try {
        final result = await repository.addFriend(event.userId);
        result.when(
          success: (_) => add(LoadFriends()), // Refresh friends after adding
          failure: (error) => emit(FriendError(error.message)),
        );
      } catch (e) {
        emit(FriendError(e.toString()));
      }
    });
  }
}