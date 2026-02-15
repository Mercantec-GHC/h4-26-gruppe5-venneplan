import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart' as login_state;
import '../../../data/repositories/login_repository_impl.dart';

class LoginBloc extends Bloc<LoginEvent, login_state.LoginState> {
  final LoginRepositoryImpl repository;

  LoginBloc({required this.repository}) : super(login_state.LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(login_state.LoginLoading());
      try {
        final success = await repository.login(event.username, event.password);
        if (success) {
          emit(login_state.LoginSuccess());
        } else {
          emit(login_state.LoginFailure('Invalid credentials'));
        }
      } catch (e) {
        emit(login_state.LoginFailure(e.toString()));
      }
    });
  }
}