import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
import '../widgets/login_form.dart';
import '../../../data/repositories/login_repository_impl.dart';
import '../../../data/datasources/login_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class LoginOverviewPage extends StatelessWidget {
  const LoginOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        repository: LoginRepositoryImpl(remoteDataSource: LoginRemoteDataSource(apiClient: ApiClient())),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitial) {
              return const LoginForm();
            }

            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LoginSuccess) {
              return const Center(child: Text('Login successful!'));
            }

            if (state is LoginFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}