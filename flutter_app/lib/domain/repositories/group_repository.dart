abstract class GroupRepository {
  Future<List<String>> fetchGroupNames();
  Future<List<String>> fetchGroupMembers(int groupId);
  Future<List<String>> addGroupMember(int groupId, int userId);
}
