import 'package:flutter_bloc/flutter_bloc.dart';
import 'friend_event.dart';
import 'friend_state.dart';
import '../../../data/repositories/friend_repository_impl.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepositoryImpl repository;
  List<Map<String, dynamic>> _allUsers = [];

  FriendBloc({required this.repository}) : super(FriendInitial()) {
    /* ---------------- LOAD FRIENDS ---------------- */

    on<LoadFriends>((event, emit) async {
      emit(FriendLoading());

      try {
        final result = await repository.fetchFriends(event.userId);
        result.when(
          success: (friends) => emit(FriendLoaded(friends)),
          failure: (error) => emit(FriendError(error.message)),
        );
      } catch (e) {
        emit(FriendError(e.toString()));
      }
    });

    /* ---------------- ADD FRIEND ---------------- */

    on<AddFriend>((event, emit) async {
      print(
        'DEBUG: AddFriend → currentUser=${event.currentUserId}, friend=${event.friendId}',
      );

      try {
        final result =
            await repository.addFriend(event.currentUserId, event.friendId);

        result.when(
          success: (_) {
            emit(FriendAdded());

            // refresh friends list silently
            add(LoadFriends(event.currentUserId));
          },
          failure: (error) {
            emit(FriendAddError(error.message));
          },
        );
      } catch (e) {
        emit(FriendAddError(e.toString()));
      }
    });

    /* ---------------- LOAD USERS ---------------- */

    on<LoadAllUsers>((event, emit) async {
      try {
        final result = await repository.fetchAllUsers();
        result.when(
          success: (users) {
            _allUsers = users;
            emit(UsersLoaded(users));
          },
          failure: (error) => emit(FriendError(error.message)),
        );
      } catch (e) {
        emit(FriendError(e.toString()));
      }
    });

    /* ---------------- SEARCH USERS ---------------- */

    on<SearchUsers>((event, emit) {
      final query = event.query.toLowerCase();

      final results = _allUsers.where((user) {
        final name = (user['name'] ?? '').toString().toLowerCase();
        final email = (user['email'] ?? '').toString().toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();

      emit(SearchResults(results));
    });

    on<ClearSearch>((event, emit) {
      emit(UsersLoaded(_allUsers));
    });
  }
}