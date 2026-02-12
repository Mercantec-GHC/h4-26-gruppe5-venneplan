import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
	final int groupId;
	final String groupName;
	const GroupInfoPage({super.key, required this.groupId, required this.groupName});

	@override
	State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  String? _selectedUserName;
  final List<String> _staticMembers = ['Alice', 'Bob', 'Charlie'];
  final List<String> _staticUsers = ['Alice', 'Bob', 'Charlie', 'David'];

  void _addMember() {
	 setState(() {
		if (_selectedUserName != null && !_staticMembers.contains(_selectedUserName)) {
		  _staticMembers.add(_selectedUserName!);
		}
	 });
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('Group: ${widget.groupName}')),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Members:', style: TextStyle(fontWeight: FontWeight.bold)),
						Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: _staticMembers.map((m) => Text(m)).toList(),
						),
						const SizedBox(height: 24),
						const Text('Add Member:', style: TextStyle(fontWeight: FontWeight.bold)),
						Row(
							children: [
								Expanded(
									child: DropdownButton<String>(
										value: _selectedUserName,
										hint: const Text('Select user'),
										isExpanded: true,
										items: _staticUsers.map((u) => DropdownMenuItem<String>(
											value: u,
											child: Text(u),
										)).toList(),
										onChanged: (val) {
											setState(() {
												_selectedUserName = val;
											});
										},
									),
								),
								ElevatedButton(
									onPressed: _addMember,
									child: const Text('Add'),
								),
							],
						),
					],
				),
			),
		);
	}
}
