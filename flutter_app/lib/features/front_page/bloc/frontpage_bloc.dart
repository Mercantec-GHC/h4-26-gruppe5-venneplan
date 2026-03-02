import 'package:bloc/bloc.dart';
import 'package:flutter_app/domain/repositories/event_repository.dart';
import 'frontpage_event.dart';
import 'frontpage_state.dart';

class FrontpageBloc extends Bloc<FrontpageEvent, FrontpageState> {
  final EventRepository repository;

  FrontpageBloc({required this.repository}) : super(FrontpageInitial()) {
    on<LoadFrontpage>(_onLoadEvents);
  }

  Future<void> _onLoadEvents(
    LoadFrontpage event,
    Emitter<FrontpageState> emit,
  ) async {
    emit(FrontpageLoading());

    final result = await repository.fetchEventsByUserId(event.userId);
    result.when(
      success: (data) => emit(FrontpageLoaded(data)),
      failure: (error) => emit(FrontpageError(error.userMessage)),
    );
  }
}
