import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

import '/../../data/repositories/login_repository_impl.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepositoryImpl repository;

  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      await repository.login(event.email, event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}