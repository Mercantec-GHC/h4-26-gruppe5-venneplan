import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../data/repositories/group_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../data/datasources/group_remote_datasource.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class GroupInfoPage extends StatelessWidget {
	final int groupId;
	final String groupName;
	const GroupInfoPage({super.key, required this.groupId, required this.groupName});

	@override
	Widget build(BuildContext context) {
		return MultiBlocProvider(
			providers: [
				BlocProvider(
					create: (context) => GroupBloc(
						repository: GroupRepositoryImpl(
							remoteDataSource: GroupRemoteDataSource(apiClient: ApiClient()),
						),
					)..add(LoadGroupMembers(groupId)),
				),
				BlocProvider(
					create: (context) => UserBloc(
						repository: UserRepositoryImpl(
							remoteDataSource: UserRemoteDataSource(apiClient: ApiClient()),
						),
					)..add(LoadUsers()),
				),
			],
			child: Builder(
				builder: (context) {
					return Scaffold(
						appBar: AppBar(title: Text('Group: $groupName')),
						body: Padding(
							padding: const EdgeInsets.all(16.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									const Text('Members:', style: TextStyle(fontWeight: FontWeight.bold)),
									BlocBuilder<GroupBloc, GroupState>(
										builder: (context, state) {
											if (state is GroupLoading) {
												return const Center(child: CircularProgressIndicator());
											} else if (state is GroupMembersLoaded) {
												if (state.memberIds.isEmpty) {
													return const Text('No members found.');
												}
												return Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: state.memberIds.map((m) => Text(m.toString())).toList(),
												);
											} else if (state is GroupError) {
												return Text('Error: ${state.message}');
											}
											return const SizedBox.shrink();
										},
									),
									const SizedBox(height: 24),
									const Text('Add Member:', style: TextStyle(fontWeight: FontWeight.bold)),
									BlocBuilder<UserBloc, UserState>(
										builder: (context, userState) {
											if (userState is UserLoading) {
												return const Center(child: CircularProgressIndicator());
											} else if (userState is UserLoaded) {
												return DropdownButton<int>(
													value: null,
													hint: const Text('Select user'),
													isExpanded: true,
													items: userState.users.map((u) => DropdownMenuItem<int>(
														value: u['id'] as int?,
														child: Text(u['name'] ?? ''),
													)).toList(),
													onChanged: (val) {
														if (val != null) {
															context.read<GroupBloc>().add(AddGroupMember(groupId, val));
														}
													},
												);
											} else if (userState is UserError) {
												return Text('Error: ${userState.message}');
											}
											return const SizedBox.shrink();
										},
									),
									BlocListener<GroupBloc, GroupState>(
										listener: (context, state) {
											if (state is GroupMemberAdded) {
												// Reload members after adding
												context.read<GroupBloc>().add(LoadGroupMembers(groupId));
											} else if (state is GroupMemberError) {
												ScaffoldMessenger.of(context).showSnackBar(
													SnackBar(content: Text('Error: ${state.message}')),
												);
											}
										},
										child: const SizedBox.shrink(),
									),
								],
							),
						),
					);
				},
			),
		);
	}
}