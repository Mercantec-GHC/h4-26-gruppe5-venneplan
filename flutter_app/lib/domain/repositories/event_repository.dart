
import 'package:flutter_app/features/events/model/event_data.dart';
import 'package:flutter_app/features/events/model/event_participant_data.dart';
import '../../../core/api/api_result.dart';

abstract class EventRepository {
  Future<ApiResult<EventData>> fetchEvent(int id);

  Future<ApiResult<List<EventParticipantData>>> fetchParticipantsByEvent(
    int eventId,
  );

  Future<ApiResult<bool>> updateParticipantStatus({
    required int eventId,
    required int userId,
    required bool isGoing,
  });
}