import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../../../data/repositories/login_repository_impl.dart';
import '../../../data/datasources/login_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class LoginOverviewPage extends StatelessWidget {
  const LoginOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Overview')),
      body: BlocProvider(
        create: (context) => LoginBloc(
          repository: LoginRepositoryImpl(
            remoteDataSource: LoginRemoteDataSource(
              apiClient: ApiClient(),
            ),
          ),
        ),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitial) {
              return const Center(child: Text('Please log in.'));
            } else if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoginSuccess) {
              return const Center(child: Text('Login successful!'));
            } else if (state is LoginFailure) {
              return Center(child: Text('Login failed: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}