import '../../core/api/api_result.dart';
import '../../data/models/group.dart';

abstract class GroupRepository {
  Future<ApiResult<List<Group>>> fetchGroups();
  Future<ApiResult<List<String>>> fetchGroupMembers(int groupId);
  Future<ApiResult<List<String>>> addGroupMember(int groupId, int userId);
  Future<ApiResult<void>> createGroup(String name);
}
