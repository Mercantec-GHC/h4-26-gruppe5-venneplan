import '../../core/api/api_result.dart';
import '../../data/models/friend.dart';

abstract class FriendRepository {
  Future<ApiResult<List<Friend>>> fetchFriends(int userId);
  Future<ApiResult<List<String>>> fetchFriendNames();
  Future<ApiResult<void>> addFriend(int currentUserId, int friendId);
  Future<ApiResult<List<Map<String, dynamic>>>> fetchAllUsers();
}