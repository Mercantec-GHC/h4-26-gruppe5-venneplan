import '../../domain/repositories/register_repository.dart';
import '../datasources/register_remote_datasource.dart';
import '../models/register_model.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> register(
    String email,
    String name,
    String password,
    String confirmPassword,
    String city,
    String gender,
    DateTime age,
  ) async {
    final user = RegisterModel(
      email: email,
      name: name,
      hashedPassword: password,
      confirmPassword: confirmPassword,
      city: city,
      gender: gender,
      age: age,
    );

    final result = await remoteDataSource.register(user);
    return result.when(
      success: (message) => true,
      failure: (error) => false,
    );
  }
}
