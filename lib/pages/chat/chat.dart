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

  // Fungsi untuk mengambil pesan dari backend
Future<void> fetchMessages() async {
    try {
      print('Fetching messages for: ${widget.loggedInPhoneNumber} and ${widget.contactPhoneNumber}');
      final response = await http.get(
  Uri.parse('http://localhost:3000/api/messages/${widget.loggedInPhoneNumber}/${widget.contactPhoneNumber}'),
  );


      if (response.statusCode == 200) {
        setState(() {
          messages = json.decode(response.body)['messages'];
        });
        print('Messages fetched successfully: ${messages.length} messages received.');
      } else {
        print("Error fetching messages: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching messages: $e");
    }
}

Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    print('Sending message: $message from ${widget.loggedInPhoneNumber} to ${widget.contactPhoneNumber}');

    setState(() {
      messages.add({
        'message': message,
        'sender_phone': widget.loggedInPhoneNumber,
      });
    });
    _controller.clear();

    try {
        final response = await http.post(
            Uri.parse('http://localhost:3000/api/send'), // Ganti dengan IP kamu
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
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                return Align(
                  alignment:
                      message['sender_phone'] == widget.loggedInPhoneNumber
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color:
                          message['sender_phone'] == widget.loggedInPhoneNumber
                              ? Colors.blue
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message'],
                      style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
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
      backgroundColor: Colors.black,
    );
  }
}
