import '../../../core/api/api_result.dart';
import '../../domain/repositories/event_repository.dart';
import '../../features/events/model/event_data.dart';
import '../../features/events/model/create_event_data.dart';
import '../../features/events/model/event_participant_data.dart';
import '../datasources/event_remote_datasource.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  Future<ApiResult<List<EventData>>> fetchEvents() async {
    final result = await remoteDataSource.fetchEvents();
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<EventData>>> fetchEventsByUserId(int userId) async {
    final participantsResult =
        await remoteDataSource.fetchParticipantsByUser(userId);
    if (participantsResult.isFailure) {
      return ApiResult.failure(participantsResult.exceptionOrNull!);
    }

    final participants = participantsResult.dataOrNull ?? [];
    final eventIds = participants
        .map((participant) => participant.eventId)
        .whereType<int>()
        .toSet();

    if (eventIds.isEmpty) {
      return ApiResult.success([]);
    }

    final eventResults = await Future.wait(
      eventIds.map(remoteDataSource.fetchEvent),
    );

    final failure = eventResults
        .where((result) => result.isFailure)
        .map((result) => result.exceptionOrNull)
        .whereType<ApiException>()
        .cast<ApiException?>()
        .firstWhere(
          (exception) => exception != null,
          orElse: () => null,
        );

    if (failure != null) {
      return ApiResult.failure(failure);
    }

    final events = eventResults
        .map((result) => result.dataOrNull)
        .whereType<EventData>()
        .toList();

    return ApiResult.success(events);
  }

  @override
  Future<ApiResult<EventData>> fetchEvent(int id) async {
    final result = await remoteDataSource.fetchEvent(id);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<EventParticipantData>>> fetchParticipantsByEvent(
    int eventId,
  ) async {
    final result = await remoteDataSource.fetchParticipantsByEvent(eventId);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<EventData>> createEvent(
    CreateEventData eventCreateData,
  ) async {
    final result = await remoteDataSource.createEvent(eventCreateData);
    return result.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<bool>> updateParticipantStatus({
    required int eventId,
    required int userId,
    required bool isGoing,
  }) async {
    final participantsResult = await fetchParticipantsByEvent(eventId);
    if (participantsResult.isFailure) {
      return ApiResult.failure(participantsResult.exceptionOrNull!);
    }

    final participants = participantsResult.dataOrNull ?? [];
    final participant = participants
        .where((p) => p.userId == userId)
        .cast<EventParticipantData?>()
        .firstWhere(
          (p) => p != null,
          orElse: () => null,
        );

    final participantId = participant?.id;
    if (participantId == null) {
      final addResult = await remoteDataSource.addParticipant(
        eventId,
        userId,
        isGoing,
      );

      return addResult.when(
        success: (_) => ApiResult.success(true),
        failure: (error) => ApiResult.failure(error),
      );
    }

    final updateResult = await remoteDataSource.updateParticipantStatus(
      participantId,
      eventId,
      isGoing,
    );

    return updateResult.when(
      success: (_) => ApiResult.success(true),
      failure: (error) => ApiResult.failure(error),
    );
  }
}