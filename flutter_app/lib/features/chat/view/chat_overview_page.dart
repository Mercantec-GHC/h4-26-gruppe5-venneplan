import 'group_info_page.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../core/config/app_config.dart';

class ChatOverviewPage extends StatefulWidget {
  const ChatOverviewPage({super.key});

  @override
  State<ChatOverviewPage> createState() => _ChatOverviewPageState();
}

class _ChatOverviewPageState extends State<ChatOverviewPage> {
  final _userController = TextEditingController();
  final _messageController = TextEditingController();
  final List<String> _messages = [];

  HubConnection? _hubConnection;

  bool get _isConnected =>
      _hubConnection?.state == HubConnectionState.connected;

  @override
  void initState() {
    super.initState();
    _initHub();
  }

  Future<void> _initHub() async {
    final apiBase = AppConfig.instance.apiBaseUrl;
    var hubBase = apiBase;
    if (hubBase.toLowerCase().endsWith('/api')) {
      hubBase = hubBase.substring(0, hubBase.length - 4);
    }
    final hubUrl = Uri.parse(hubBase.endsWith('/') ? '${hubBase}chathub' : '$hubBase/chathub');

    final connection = HubConnectionBuilder()
        .withUrl(hubUrl.toString(), HttpConnectionOptions())
        .build();

    connection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final user = arguments[0]?.toString() ?? '';
        final message = arguments.length > 1 ? arguments[1]?.toString() ?? '' : '';
        final encoded = '$user: $message';
        setState(() => _messages.add(encoded));
      }
    });

    setState(() => _hubConnection = connection);

    try {
      await connection.start();
      setState(() {});
    } catch (_) {
      // Connection may fail during development; keep UI responsive
    }
  }

  Future<void> _send() async {
    if (_hubConnection == null) return;
    final user = _userController.text.trim();
    final message = _messageController.text.trim();
    if (user.isEmpty || message.isEmpty) return;

    try {
      await _hubConnection?.invoke('SendMessage', args: [user, message]);
      _messageController.clear();
    } catch (_) {
      // ignore invocation errors for now
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _messageController.dispose();
    _hubConnection?.stop();
    _hubConnection = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'User'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isConnected ? _send : null,
                  child: const Text('Send'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(_isConnected ? 'Connected' : 'Disconnected'),
          ],
        ),
      ),
    );
  }
}