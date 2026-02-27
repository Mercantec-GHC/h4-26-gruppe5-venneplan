import '../../core/api/api_result.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> fetchUserNames() async {
    final result = await remoteDataSource.fetchUserNames();
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }
}