import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String senderPhone;
  final String message;
  final DateTime createdAt;
  final String? senderName;
  final String? senderPhoto;

  Message({
    required this.senderPhone,
    required this.message,
    required this.createdAt,
    this.senderName,
    this.senderPhoto,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderPhone: json['sender_phone'],
      message: json['message'],
      createdAt: DateTime.parse(json['sent_at']),
      senderName: json['sender_name'],
      senderPhoto: json['sender_photo'],
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
    required this.loggedInPhoneNumber,
    String? groupPhoto,
    required String groupDescription,
  }) : super(key: key);

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _startPeriodicFetch();  // Keep only one definition of this method
  }

 Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final url =
          'http://192.168.2.13:3000/api/group/${widget.groupId}/send-message';
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
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Failed to send message';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }
  // Fetch messages from the API
  Future<void> fetchMessages() async {
    final url = 'http://192.168.2.13:3000/api/group/${widget.groupId}/messages';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> messagesList = json.decode(response.body);
      if (mounted) {
        setState(() {
          messages =
              messagesList.map((json) => Message.fromJson(json)).toList();
        });
      }
    }
  }

  // Start a periodic timer to refresh messages every 5 seconds
  void _startPeriodicFetch() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchMessages();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the page is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  // Utility to get the sender's photo URL
  String getSenderPhotoUrl(String? photo) {
    final String photoPath = photo?.replaceAll('\\', '/') ?? 'default.jpg';
    return 'http://192.168.2.13:3000/$photoPath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Color(0xFF075E54),
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
                      final isMe =
                          message.senderPhone == widget.loggedInPhoneNumber;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe && message.senderPhoto != null)
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      getSenderPhotoUrl(message.senderPhoto)),
                                  radius: 18,
                                ),
                              if (!isMe) SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: message.message.length > 40
                                        ? 250
                                        : 180, // Adjust the maxWidth based on message length
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe)
                                        Text(
                                          message.senderName ?? 
                                              message.senderPhone,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      Text(
                                        message.message,
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Align(
                                        alignment: isMe
                                            ? Alignment.bottomRight
                                            : Alignment
                                                .bottomLeft, // Time alignment
                                        child: Text(
                                          '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8),
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
