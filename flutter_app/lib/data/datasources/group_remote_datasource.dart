import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';
import '../models/group.dart';

class GroupRemoteDataSource {
  final ApiClient apiClient;

  GroupRemoteDataSource({required this.apiClient});

    Future<ApiResult<void>> createGroup(String name) async {
      return await apiClient.post<void>(
        '/Groups/create',
        body: {'name': name},
        fromJson: (_) => null,
      );
    }

  Future<ApiResult<List<Group>>> fetchGroups() async {
    return await apiClient.get<List<Group>>(
      '/Groups/get',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => Group.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw FormatException('Expected JSON array, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<List<String>>> fetchGroupMembers(int groupId) async {
    return await apiClient.get<List<String>>(
      '/Groups/getGroupMembers/$groupId',
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
              throw FormatException('Unexpected member entry: $e');
            }
          }).toList();
        }
        throw FormatException('Expected JSON array, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<List<String>>> addGroupMember(int groupId, int userId) async {
    return await apiClient.post<List<String>>(
      '/Groups/addGroupMember',
      body: {'groupId': groupId, 'userId': userId},
      // Results from fetch could cause errors, due to incorrect types.
      // Therefore i added if statements, to handle the results giving, what was needed.
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
              throw FormatException('Unexpected member entry: $e');
            }
          }).toList();
        } else if (json is Map) {
          // Same scenario as above, but with api return response causing errors.
          final members = json['members'] ?? json['data'] ?? json['result'];
          if (members is List) {
            return members.map((e) {
              if (e is Map<String, dynamic>) {
                return e['name'] as String;
              } else if (e is Map && e.containsKey('name')) {
                return e['name'] as String;
              } else if (e is String) {
                return e;
              } else {
                throw FormatException('Unexpected member entry: $e');
              }
            }).toList();
          }
          return <String>[];
        }
        throw FormatException('Expected JSON array or map, got ${json.runtimeType}');
      },
    );
  }

  // Endpoint not yet made, but should end up similar to this.
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
