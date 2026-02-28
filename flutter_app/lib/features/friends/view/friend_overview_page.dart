import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/friend_bloc.dart';
import '../bloc/friend_event.dart';
import '../bloc/friend_state.dart';

class FriendOverviewPage extends StatelessWidget {
  const FriendOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friends')),
      body: BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          if (state is FriendLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FriendLoaded) {
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
          } else if (state is FriendError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No friends found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add friend functionality
        },
        child: Icon(Icons.add),
      ),
    );
  }
}