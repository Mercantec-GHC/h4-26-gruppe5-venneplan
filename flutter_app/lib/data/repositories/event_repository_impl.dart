import '../../../core/api/api_result.dart';
import 'package:flutter_app/domain/repositories/event_repository.dart';
import 'package:flutter_app/features/events/model/event_data.dart';
import 'package:flutter_app/features/events/model/event_participant_data.dart';
import '../datasources/event_remote_datasource.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

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
        success: (data) => ApiResult.success(data),
        failure: (error) => ApiResult.failure(error),
      );
    }

    final updateResult = await remoteDataSource.updateParticipantStatus(
      participantId,
      eventId,
      isGoing,
    );

    return updateResult.when(
      success: (data) => ApiResult.success(data),
      failure: (error) => ApiResult.failure(error),
    );
  }
}