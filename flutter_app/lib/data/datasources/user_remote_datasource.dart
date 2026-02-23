import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';

class UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSource({required this.apiClient});

Future<ApiResult<List<Map<String, dynamic>>>> fetchUserNames() async {
    return await apiClient.get<List<Map<String, dynamic>>>(
      '/Users/get',
      fromJson: (json) {
        if (json is List) {
          return json.map<Map<String, dynamic>>((e) => {
            'id': e['id'] ?? e['userId'] ?? e['UserId'],
            'name': e['name'] ?? e['Name'],
          }).toList();
        }
        throw FormatException('Expected JSON array, got ${json.runtimeType}');
      },
    );
  }
}