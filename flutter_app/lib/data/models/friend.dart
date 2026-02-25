import 'user.dart';

class Friend {
  final int userId;
  final int friendId;
  final int friendScore;
  final String friendRequestStatus;
  final User? user;

  Friend({
    required this.userId,
    required this.friendId,
    required this.friendScore,
    this.friendRequestStatus = "pending",
    this.user,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['userId'] as int,
      friendId: json['friendId'] as int,
      friendScore: json['friendScore'] as int,
      friendRequestStatus: json['friendRequestStatus'] as String? ?? "pending",
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }
}