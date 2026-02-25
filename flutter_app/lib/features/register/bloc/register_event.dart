import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;
  final String city;
  final String gender;
  final DateTime age;

  const RegisterButtonPressed({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.city,
    required this.gender,
    required this.age,
  });

  @override
  List<Object?> get props =>
      [email, name, password, confirmPassword, city, gender, age];
}
