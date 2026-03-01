import 'package:flutter_app/core/api/api_result.dart';
import '../../domain/repositories/friend_repository.dart';
import '../datasources/friend_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/friend.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDataSource remoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  FriendRepositoryImpl({
    required this.remoteDataSource,
    required this.userRemoteDataSource,
  });

  @override
  Future<ApiResult<List<Friend>>> fetchFriends(int userId) async {
    final result = await remoteDataSource.fetchFriends(userId);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<String>>> fetchFriendNames() async {
    final result = await remoteDataSource.fetchFriendNames();
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> addFriend(int currentUserId, int friendId) async {
    final result = await remoteDataSource.addFriend(currentUserId, friendId);
    return result.when(
      success: (_) => ApiResult.success(null),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> fetchAllUsers() async {
    final result = await userRemoteDataSource.fetchAllUsers();
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }
}