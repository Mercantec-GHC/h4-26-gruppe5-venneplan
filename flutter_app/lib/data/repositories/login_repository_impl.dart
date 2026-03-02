import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_datasource.dart';

class LoginRepositoryImpl implements LoginRepository{
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> login(String email, String password) async {
    final result = await remoteDataSource.login(email, password);
    return result.when(
      success: (token) => true,
      failure: (error) => false,
    );
  }
}