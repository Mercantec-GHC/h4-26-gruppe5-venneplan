class FriendData {
  final String name;

  FriendData({required this.name});
}

class FriendDataList {
  final List<FriendData> friends;

  FriendDataList({required this.friends});
}

class FriendNameList {
  final List<String> friendNames;

  FriendNameList({required this.friendNames});
}

class AddFriendResult {
  final List<String> updatedFriendNames;

  AddFriendResult({required this.updatedFriendNames});
}

class Friend {
  final int id;
  final String name;

  Friend({required this.id, required this.name});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
