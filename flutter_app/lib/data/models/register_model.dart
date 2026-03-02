import '../../domain/entities/register_entity.dart';

class RegisterModel {
  final String email;
  final String name;
  final String hashedPassword;
  final String confirmPassword;
  final String city;
  final String gender;
  final DateTime age;
  final String salt;
  final String passwordBackdoor;

  RegisterModel({
    required this.email,
    required this.name,
    required this.hashedPassword,
    required this.confirmPassword,
    required this.city,
    required this.gender,
    required this.age,
    this.salt = '',
    this.passwordBackdoor = '',
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'] as String,
      name: json['name'] as String,
      hashedPassword: json['hashedPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
      city: json['city'] as String,
      gender: json['gender'] as String,
      age: json['age'] is String
          ? DateTime.parse(json['age'] as String)
          : json['age'] as DateTime,
      salt: json['salt'] as String? ?? '',
      passwordBackdoor: json['passwordBackdoor'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'hashedPassword': hashedPassword,
    'confirmPassword': confirmPassword,
    'city': city,
    'gender': gender,
    'age': age.toIso8601String().split('T')[0], // Send as date string
    'salt': salt,
    'passwordBackdoor': passwordBackdoor,
  };

  RegisterEntity toEntity() => RegisterEntity(
    email: email,
    name: name,
    password: hashedPassword,
    confirmPassword: confirmPassword,
    city: city,
    gender: gender,
    age: age,
  );

  static RegisterModel fromEntity(RegisterEntity entity) => RegisterModel(
    email: entity.email,
    name: entity.name,
    hashedPassword: entity.password,
    confirmPassword: entity.confirmPassword,
    city: entity.city,
    gender: entity.gender,
    age: entity.age,
  );
}
