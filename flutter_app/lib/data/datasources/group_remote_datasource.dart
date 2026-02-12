import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';

class GroupRemoteDataSource {
  final ApiClient apiClient;

  GroupRemoteDataSource({required this.apiClient});

  Future<ApiResult<List<String>>> fetchGroupNames() async {
    return await apiClient.get<List<String>>(
      '/Groups/get',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => e['name'] as String).toList();
        }
        throw FormatException('Expected JSON array, got \\${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<List<String>>> fetchGroupMembers(int groupId) async {
    return await apiClient.get<List<String>>(
      '/Groups/getGroupMembers/$groupId',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => e['name'] as String).toList();
        }
        throw FormatException('Expected JSON array, got \${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<List<String>>> addGroupMember(int groupId, int userId) async {
    return await apiClient.post<List<String>>(
      '/Groups/addGroupMember',
      body: {'groupId': groupId, 'userId': userId},
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => e['name'] as String).toList();
        }
        throw FormatException('Expected JSON array, got \\${json.runtimeType}');
      },
    );
  }

  // endpoint not yet made, but should end up similar to this
  /*Future<ApiResult<List<ChatData>>> fetchGroupChats(int groupId) async {
    return await apiClient.get<List<ChatData>>(
      '/Groups/$groupId/chats',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => ChatData(
            name: e['name'] as String?,
            participantCount: (e['participantCount'] as List).map((p) => p as int).toList(),
            message: e['message'] as String?,
            chatId: e['chatId'] as int,
          )).toList();
        }
        throw FormatException('Expected JSON array, got \\${json.runtimeType}');
      },
    );
  }*/
}
