import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';
import '../models/friend.dart';

class FriendRemoteDataSource {
  final ApiClient apiClient;

  FriendRemoteDataSource({required this.apiClient});

  Future<ApiResult<List<Friend>>> fetchFriends(int userId) async {
    return await apiClient.get<List<Friend>>(
      '/Friends/user/$userId',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => Friend.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw FormatException('Expected JSON array, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<List<String>>> fetchFriendNames() async {
    return await apiClient.get<List<String>>(
      '/Friends/getFriendNames',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) {
            if (e is Map<String, dynamic>) {
              return e['name'] as String;
            } else if (e is Map && e.containsKey('name')) {
              return e['name'] as String;
            } else if (e is String) {
              return e;
            } else {
              throw FormatException('Unexpected friend entry: $e');
            }
          }).toList();
        }
        throw FormatException('Expected JSON array, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<void>> addFriend(int currentUserId, int friendId) async {
    print('DEBUG: FriendRemoteDataSource.addFriend called with currentUserId=$currentUserId, friendId=$friendId');
    try {
      final result = await apiClient.post<void>(
        '/Friends/addFriend',
        body: {
          'userId': currentUserId,
          'friendId': friendId,
          'friendScore': 0,
          'friendRequestStatus': 'pending',
        },
        fromJson: (json) {
          // Backend returns the Friend object, but we don't need to parse it
          return null;
        },
      );
      print('DEBUG: API response received: $result');
      return result;
    } catch (e) {
      print('DEBUG: Exception in addFriend: $e');
      rethrow;
    }
  }
}