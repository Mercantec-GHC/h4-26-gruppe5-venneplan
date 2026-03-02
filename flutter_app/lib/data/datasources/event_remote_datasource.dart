
import 'package:flutter_app/features/events/model/create_event_data.dart';
import 'package:flutter_app/features/events/model/event_data.dart';
import 'package:flutter_app/features/events/model/event_participant_data.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';

class EventRemoteDataSource {
  final ApiClient apiClient;

  EventRemoteDataSource({required this.apiClient});

  Future<ApiResult<List<EventData>>> fetchEvents() async {
    return await apiClient.get<List<EventData>>(
      '/Event',
      fromJson: (json) {
        if (json is List) {
          return json
              .map(
                (item) => EventData.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw FormatException('Expected JSON list, got ${json.runtimeType}');
      },
    );
  }

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

  Future<ApiResult<List<EventParticipantData>>> fetchParticipantsByUser(
    int userId,
  ) async {
    return await apiClient.get<List<EventParticipantData>>(
      '/EventParticipant/participants/user/$userId',
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

  Future<ApiResult<EventParticipantData>> updateParticipantStatus(
    int participantId,
    int eventId,
    bool isGoing,
  ) async {
    return await apiClient.put<EventParticipantData>(
      '/EventParticipant/participants/$participantId',
      body: {
        'participantId': participantId,
        'eventId': eventId,
        'isGoing': isGoing,
      },
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return EventParticipantData.fromJson(json);
        }
        throw FormatException('Expected JSON object, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<EventParticipantData>> addParticipant(
    int eventId,
    int userId,
    bool isGoing,
  ) async {
    return await apiClient.post<EventParticipantData>(
      '/EventParticipant/participants',
      body: {
        'eventId': eventId,
        'userId': userId,
        'isGoing': isGoing,
      },
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return EventParticipantData.fromJson(json);
        }
        throw FormatException('Expected JSON object, got ${json.runtimeType}');
      },
    );
  }

  Future<ApiResult<EventData>> createEvent(
    CreateEventData event,
  ) async {
    return await apiClient.post<EventData>(
      '/Event',
      body: event.toJson(),
      fromJson: (json) => EventData.fromJson(json as Map<String, dynamic>),
    );
  }
}
