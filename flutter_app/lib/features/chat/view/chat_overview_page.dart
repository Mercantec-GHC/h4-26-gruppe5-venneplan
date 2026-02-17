import 'group_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

import '../../../data/repositories/group_repository_impl.dart';
import '../../../data/datasources/group_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class ChatOverviewPage extends StatelessWidget {
  const ChatOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final bloc = BlocProvider.of<GroupBloc>(context);
              bloc.add(LoadGroups());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => GroupBloc(
          repository: GroupRepositoryImpl(
            remoteDataSource: GroupRemoteDataSource(
              apiClient: ApiClient(),
            ),
          ),
        )..add(LoadGroups()),
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupLoaded) {
              if (state.groupNames.isEmpty) {
                return const Center(child: Text('No groups found.'));
              }
              return ListView.builder(
                itemCount: state.groupNames.length,
                itemBuilder: (context, index) {
                  final groupId = index;
                  return ListTile(
                    title: Text(state.groupNames[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupInfoPage(groupId: groupId, groupName: state.groupNames[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is GroupError) {
              return Center(child: Text('Error: \\${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}