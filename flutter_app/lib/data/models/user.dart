class User {
  final int id;
  final String email;
  final String name;
  final String userTag;
  final String hashedPassword;
  final String salt;
  final DateTime lastLogin;
  final String city;
  final String gender;
  final DateTime age;
  final String role;
  final String token;
  final String? passwordBackdoor;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.userTag,
    required this.hashedPassword,
    required this.salt,
    required this.lastLogin,
    required this.city,
    required this.gender,
    required this.age,
    required this.role,
    required this.token,
    this.passwordBackdoor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      userTag: json['userTag'] as String,
      hashedPassword: json['hashedPassword'] as String,
      salt: json['salt'] as String,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      city: json['city'] as String,
      gender: json['gender'] as String,
      age: DateTime.parse(json['age'] as String),
      role: json['role'] as String,
      token: json['token'] as String,
      passwordBackdoor: json['passwordBackdoor'] as String?,
    );
  }
}
