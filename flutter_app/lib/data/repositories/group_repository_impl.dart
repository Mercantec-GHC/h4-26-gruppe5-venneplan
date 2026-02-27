import '../../core/api/api_result.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_datasource.dart';
import '../models/group.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override

  @override
  Future<ApiResult<List<Group>>> fetchGroups() async {
    final result = await remoteDataSource.fetchGroups();
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<String>>> fetchGroupMembers(int groupId) async {
    final result = await remoteDataSource.fetchGroupMembers(groupId);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<String>>> addGroupMember(int groupId, int userId) async {
    final result = await remoteDataSource.addGroupMember(groupId, userId);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> createGroup(String name) async {
    final result = await remoteDataSource.createGroup(name);
    return result.when(
      success: (_) => ApiResult.success(null),
      failure: (error) => ApiResult.failure(error),
    );
  }
}
