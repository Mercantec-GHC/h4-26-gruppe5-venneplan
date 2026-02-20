import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';
import '../models/register_model.dart';

abstract class RegisterRemoteDataSource {
  Future<ApiResult<String>> register(RegisterModel user);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final ApiClient apiClient;

  RegisterRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ApiResult<String>> register(RegisterModel user) async {
    return await apiClient.post<String>(
      '/users/register',
      body: user.toJson(),
      fromJson: (json) {
        if (json is Map<String, dynamic> && json.containsKey('message')) {
          return json['message'] as String;
        }
        throw FormatException('Expected JSON object with a message field, got ${json.runtimeType}');
      },
    );
  }
}