import '../../core/api/api_result.dart';

abstract class UserRepository {
  Future<ApiResult<List<Map<String, dynamic>>>> fetchUserNames();
}