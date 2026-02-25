abstract class RegisterRepository {
  Future<bool> register(
    String email,
    String name,
    String password,
    String confirmPassword,
    String city,
    String gender,
    DateTime age,
  );
}
