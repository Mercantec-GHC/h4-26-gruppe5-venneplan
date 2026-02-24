import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';

class LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSource({required this.apiClient});

  Future<ApiResult<String>> login(String email, String password) async {
    return await apiClient.post<String>(
      '/Users/login',
      body: {'email': email, 'password': password},
      fromJson: (json) {
        if (json is Map<String, dynamic> && json.containsKey('token')) {
          return json['token'] as String;
        }
        throw FormatException('Expected JSON object with a token field, got \\${json.runtimeType}');
      },
    );
  }
}