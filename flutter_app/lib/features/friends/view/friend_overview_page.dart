import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/friend_bloc.dart';
import '../bloc/friend_event.dart';
import '../bloc/friend_state.dart';
import '../widgets/add_friend_dialog.dart';

class FriendOverviewPage extends StatefulWidget {
  const FriendOverviewPage({super.key});

  @override
  State<FriendOverviewPage> createState() => _FriendOverviewPageState();
}

class _FriendOverviewPageState extends State<FriendOverviewPage> {
  static const int _currentUserId = 1;

  @override
  void initState() {
    super.initState();
    context.read<FriendBloc>().add(LoadFriends(_currentUserId));
  }

  void _openAddFriendPage() {
    final bloc = context.read<FriendBloc>();

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: AddFriendDialog(currentUserId: _currentUserId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          if (state is FriendLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FriendLoaded) {
            if (state.friends.isEmpty) {
              return const Center(child: Text('No friends yet.'));
            }

            return ListView.builder(
              itemCount: state.friends.length,
              itemBuilder: (context, index) {
                final friend = state.friends[index];
                return ListTile(
                  title: Text(friend.user?.name ?? 'Unknown'),
                  subtitle: Text(friend.user?.email ?? 'Unknown'),
                );
              },
            );
          }

          if (state is FriendError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddFriendPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}