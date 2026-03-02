import 'package:flutter_app/features/events/model/event_data.dart';
import 'package:flutter_app/features/events/model/event_participant_data.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';

class EventRemoteDataSource {
  final ApiClient apiClient;

  EventRemoteDataSource({required this.apiClient});

  Future<ApiResult<EventData>> fetchEvent(int id) async {
    return await apiClient.get<EventData>(
      '/Event/$id',
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return EventData.fromJson(json);
        }
        throw FormatException('Expected JSON object, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<List<EventParticipantData>>> fetchParticipantsByEvent(
    int eventId,
  ) async {
    return await apiClient.get<List<EventParticipantData>>(
      '/EventParticipant/participants/$eventId',
      fromJson: (json) {
        if (json is List) {
          return json
              .map(
                (item) => EventParticipantData.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw FormatException('Expected JSON list, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<bool>> updateParticipantStatus(
    int participantId,
    int eventId,
    bool isGoing,
  ) async {
    return await apiClient.put<bool>(
      '/EventParticipant/participants/$participantId',
      body: {
        'participantId': participantId,
        'eventId': eventId,
        'isGoing': isGoing,
      },
      fromJson: (_) => true,
    );
  }

  Future<ApiResult<bool>> addParticipant(
    int eventId,
    int userId,
    bool isGoing,
  ) async {
    return await apiClient.post<bool>(
      '/EventParticipant/participants',
      body: {
        'eventId': eventId,
        'userId': userId,
        'isGoing': isGoing,
      },
      fromJson: (_) => true,
    );
  }
}
