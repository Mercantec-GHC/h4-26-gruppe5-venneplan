import '../../core/api/api_result.dart';
import '../../data/models/friend.dart';

abstract class FriendRepository {
  Future<ApiResult<List<Friend>>> fetchFriends();
  Future<ApiResult<List<String>>> fetchFriendNames();
  Future<ApiResult<List<String>>> addFriend(int userId);
}