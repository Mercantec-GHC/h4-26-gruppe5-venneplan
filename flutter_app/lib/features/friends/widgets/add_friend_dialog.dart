import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/friend_bloc.dart';
import '../bloc/friend_event.dart';
import '../bloc/friend_state.dart';

class AddFriendDialog extends StatefulWidget {
  final int currentUserId;
  const AddFriendDialog({super.key, required this.currentUserId});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _addedUsers = {};

  @override
  void initState() {
    super.initState();
    context.read<FriendBloc>().add(LoadAllUsers());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<FriendBloc>().add(
          query.isEmpty ? LoadAllUsers() : SearchUsers(query),
        );
  }

  void _addFriend(int userId) {
    context.read<FriendBloc>().add(
          AddFriend(widget.currentUserId, userId),
        );

    setState(() {
      _addedUsers.add(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH FIELD (ALWAYS VISIBLE)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 📜 USERS LIST
          Expanded(
            child: BlocBuilder<FriendBloc, FriendState>(
              builder: (context, state) {
                if (state is FriendInitial ||
                    state is FriendLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is UsersLoaded) {
                  return _buildList(state.users);
                }

                if (state is SearchResults) {
                  return _buildList(state.results);
                }

                if (state is FriendError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> users) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        final dynamic rawId = user['id'];
        final int? userId =
            rawId is int ? rawId : int.tryParse(rawId.toString());

        if (userId == null || userId == widget.currentUserId) {
          return const SizedBox.shrink();
        }

        final isAdded = _addedUsers.contains(userId);

        return ListTile(
          title: Text(user['name'] ?? 'Unknown'),
          subtitle: Text(user['email'] ?? ''),
          trailing: ElevatedButton(
            onPressed: isAdded ? null : () => _addFriend(userId),
            child: Text(isAdded ? 'Added' : 'Add'),
          ),
        );
      },
    );
  }
}