class EventData {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? date;
  final String? adress;
  final int? hostId;
  final Map<String, dynamic>? host;
  final int? participantCount;

  EventData({
    this.id,
    this.title,
    this.description,
    this.date,
    this.adress,
    this.hostId,
    this.host,
    this.participantCount,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'adress': String adress,
        'date': String date,
        'hostId': int hostId,
      } =>
        EventData(
          id: id,
          title: title,
          description: json['description'] as String?,
          date: DateTime.parse(date),
          adress: adress,
          hostId: hostId,
          host: json['host'] is Map<String, dynamic>
              ? json['host'] as Map<String, dynamic>
              : null,
          participantCount: json['participantCount'] as int? ?? 0,
        ),
      _ => throw const FormatException('Invalid Event JSON'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date?.toIso8601String(),
      'adress': adress,
      'hostId': hostId,
      'host': host,
      'participantCount': participantCount,
    };
  }
}