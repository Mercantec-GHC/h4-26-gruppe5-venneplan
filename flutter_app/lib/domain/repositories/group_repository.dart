import '../../core/api/api_result.dart';

abstract class GroupRepository {
  Future<ApiResult<List<String>>> fetchGroupNames();
  Future<ApiResult<List<String>>> fetchGroupMembers(int groupId);
  Future<ApiResult<List<String>>> addGroupMember(int groupId, int userId);
  Future<ApiResult<void>> createGroup(String name);
}
