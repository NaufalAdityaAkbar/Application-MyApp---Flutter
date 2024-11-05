import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String senderPhone;
  final String message;
  final DateTime createdAt;
  final String? senderName;

  Message({
    required this.senderPhone,
    required this.message,
    required this.createdAt,
    this.senderName,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderPhone: json['sender_phone'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      senderName: json['sender_name'],
    );
  }
}

class GroupDetailPage extends StatefulWidget {
  final int groupId;
  final String groupName;
  final String loggedInPhoneNumber;

  const GroupDetailPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.loggedInPhoneNumber, required String groupDescription, String? groupPhoto,
  }) : super(key: key);

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final url = 'http://192.168.2.13:3000/api/group/${widget.groupId}/messages';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> messagesList = json.decode(response.body);
      setState(() {
        messages = messagesList.map((json) => Message.fromJson(json)).toList();
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final url = 'http://192.168.2.13:3000/api/group/${widget.groupId}/send-message';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'groupId': widget.groupId,
          'senderPhoneNumber': widget.loggedInPhoneNumber,
          'message': message,
        }),
      );

      if (response.statusCode == 201) {
        _messageController.clear();
        fetchMessages();
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? 'Failed to send message';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: const Color.fromARGB(255, 155, 155, 155),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text('No messages in this group.'))
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderPhone == widget.loggedInPhoneNumber;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Text(
                                  message.senderName ?? message.senderPhone,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              SizedBox(height: 5),
                              Text(
                                message.message,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
