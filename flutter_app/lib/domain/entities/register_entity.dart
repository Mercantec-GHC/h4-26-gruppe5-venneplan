import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;
  final String city;
  final String gender;
  final DateTime age;

  const RegisterEntity({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.city,
    required this.gender,
    required this.age,
  });

  @override
  List<Object?> get props => [
    email,
    name,
    password,
    confirmPassword,
    city,
    gender,
    age,
  ];
}
