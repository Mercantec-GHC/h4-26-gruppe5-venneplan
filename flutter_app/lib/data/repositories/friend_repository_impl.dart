import 'package:flutter_app/core/api/api_result.dart';
import '../../domain/repositories/friend_repository.dart';
import '../datasources/friend_remote_datasource.dart';
import '../models/friend.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDataSource remoteDataSource;

  FriendRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<Friend>>> fetchFriends() async {
    final result = await remoteDataSource.fetchFriends();
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
  Future<ApiResult<List<String>>> addFriend(int userId) async {
    final result = await remoteDataSource.addFriend(userId);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }
}