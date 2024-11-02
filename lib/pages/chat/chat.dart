import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatDetailPage extends StatefulWidget {
  final String contactName;
  final String contactPhoneNumber;
  final String loggedInPhoneNumber;

  ChatDetailPage({
    required this.contactName,
    required this.contactPhoneNumber,
    required this.loggedInPhoneNumber,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) fetchMessages();
    });
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/messages/${widget.loggedInPhoneNumber}/${widget.contactPhoneNumber}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          messages = json.decode(response.body)['messages'];
        });

        if (messages.isNotEmpty) {
          await markMessagesAsRead();
        }
      } else {
        print("Error fetching messages: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching messages: $e");
    }
  }

  Future<void> markMessagesAsRead() async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:3000/api/messages/read/${widget.contactPhoneNumber}/${widget.loggedInPhoneNumber}'),
      );

      if (response.statusCode == 200) {
        print('Messages marked as read successfully.');
      } else {
        print("Error marking messages as read: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception marking messages as read: $e");
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({
        'message': message,
        'sender_phone': widget.loggedInPhoneNumber,
        'created_at': DateTime.now().toString(),
        'unread_count': 0,
      });
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/send'),
        body: jsonEncode({
          'sender_phone': widget.loggedInPhoneNumber,
          'receiver_phone': widget.contactPhoneNumber,
          'message': message,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        print('Message sent successfully.');
      } else {
        print("Error sending message: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        backgroundColor: Color.fromARGB(218, 254, 250, 224),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isSender = message['sender_phone'] == widget.loggedInPhoneNumber;
                bool isRead = message['unread_count'] == 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Align(
                    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSender ? Color.fromARGB(160, 60, 61, 55) : Color.fromARGB(160, 60, 61, 55),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: isSender ? Radius.circular(15) : Radius.zero,
                          bottomRight: isSender ? Radius.zero : Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['message'],
                            style: TextStyle(
                              color: isSender ? Colors.white : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message['created_at'], // Show message timestamp
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.check_circle,
                                color: isRead ? Colors.orange : Color.fromARGB(217, 187, 133, 52), // Gray for unread, orange for read
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (value) {
                      sendMessage(value);
                    },
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Color.fromARGB(255, 187, 133, 52)),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(218, 254, 250, 224),
    );
  }
}
