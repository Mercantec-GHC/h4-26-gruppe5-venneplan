class CreateEventData {
  final String title;
  final String adress;
  final DateTime date;
  final String description;
  final int hostId;

  CreateEventData({
    required this.title,
    required this.adress,
    required this.date,
    required this.description,
    required this.hostId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'adress': adress,
      'date': date.toUtc().toIso8601String(),
      'description': description,
      'hostId': hostId,
    };
  }
}
