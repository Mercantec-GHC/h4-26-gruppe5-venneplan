class EventParticipantData {
  final int? id;
  final int? eventId;
  final Map<String, dynamic>? event;
  final int? userId;
  final Map<String, dynamic>? user;
  final bool? isGoing;

  EventParticipantData({
    this.id,
    this.eventId,
    this.event,
    this.userId,
    this.user,
    this.isGoing,
  });

  factory EventParticipantData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'eventId': int eventId,
        'userId': int userId,
        'isGoing': bool isGoing,
      } =>
        EventParticipantData(
          id: json['id'] as int?,
          eventId: eventId,
          userId: userId,
          isGoing: isGoing,
          event: json['event'] is Map<String, dynamic>
              ? json['event'] as Map<String, dynamic>
              : null,
          user: json['user'] is Map<String, dynamic>
              ? json['user'] as Map<String, dynamic>
              : null,
        ),
      _ => throw const FormatException('Invalid EventParticipant JSON'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'event': event,
      'userId': userId,
      'user': user,
      'isGoing': isGoing,
    };
  }
}
