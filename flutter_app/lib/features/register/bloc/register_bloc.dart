import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_event.dart';
import 'register_state.dart';

import '../../../data/repositories/register_repository_impl.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepositoryImpl repository;

  RegisterBloc({required this.repository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        final success = await repository.register(
          event.email,
          event.name,
          event.password,
          event.confirmPassword,
          event.city,
          event.gender,
          event.age,
        );
        if (success) {
          emit(RegisterSuccess());
        } else {
          emit(const RegisterFailure('Registration failed'));
        }
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
