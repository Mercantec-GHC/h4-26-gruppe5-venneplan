import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group/group_bloc.dart';
import '../bloc/group/group_event.dart';
import '../bloc/group/group_state.dart';

import '../../../data/repositories/group_repository_impl.dart';
import '../../../data/datasources/group_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: BlocProvider(
        create: (context) => GroupBloc(
          repository: GroupRepositoryImpl(
            remoteDataSource: GroupRemoteDataSource(
              apiClient: ApiClient(),
            ),
          ),
        ),
        child: BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupCreated) {
              _controller.clear();
              // Pop to root so the navbar remains visible
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state is GroupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        final name = _controller.text.trim();
                        if (name.isNotEmpty) {
                          context.read<GroupBloc>().add(CreateGroup(name));
                        }
                      },
                      child: state is GroupLoading
                          ? const CircularProgressIndicator()
                          : const Text('Create Group'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
