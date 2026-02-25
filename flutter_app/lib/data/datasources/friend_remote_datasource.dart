import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';
import '../models/friend.dart';

class FriendRemoteDataSource {
  final ApiClient apiClient;

  FriendRemoteDataSource({required this.apiClient});

  Future<ApiResult<List<Friend>>> fetchFriends() async {
    return await apiClient.get<List<Friend>>(
      '/Friends/get',
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

  Future<ApiResult<List<String>>> addFriend(int userId) async {
    return await apiClient.post<List<String>>(
      '/Friends/add',
      body: {'userId': userId},
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
}