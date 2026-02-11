import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_datasource.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<String>> fetchGroupNames() async {
    final result = await remoteDataSource.fetchGroupNames();
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.message),
    );
  }

  @override
  Future<List<String>> fetchGroupMembers(int groupId) async {
    final result = await remoteDataSource.fetchGroupMembers(groupId);
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.message),
    );
  }

  @override
  Future<List<String>> addGroupMember(int groupId, int userId) async {
    final result = await remoteDataSource.addGroupMember(groupId, userId);
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.message),
    );
  }
}
