import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../contact/contact.dart';
import 'package:myapp/pages/settingmenu.dart';
import 'chat.dart';

class ChatPage extends StatefulWidget {
  final String loggedInPhoneNumber;

  ChatPage({required this.loggedInPhoneNumber});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

Future<void> fetchChats() async {
    try {
        final response = await http.get(
          Uri.parse('http://localhost:3000/api/chat/list/${widget.loggedInPhoneNumber}'),
        );

        if (response.statusCode == 200) {
            setState(() {
                chats = json.decode(response.body);
                isLoading = false;
            });
        } else {
            throw Exception('Failed to load chats');
        }
    } catch (e) {
        print('Error fetching chats: $e');
        setState(() {
            isLoading = false;
        });
    }
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'BeeChat',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.camera_alt_outlined, color: Colors.orange),
          onPressed: () {
            // Action for camera
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.orange),
          onPressed: () {
            // Action for searching chats
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.orange),
          onSelected: (value) {
            if (value == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingMenu()),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              'New group',
              'New broadcast',
              'Linked devices',
              'Starred messages',
              'Settings',
            ].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : chats.isEmpty
            ? Center(
                child: Text(
                  'No chats available',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[800],
                  height: 1,
                  indent: 80,
                ),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat['photo']),
                    ),
                    title: Text(
                      chat['contact_name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      chat['message'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: chat['unread_count'] > 0
                        ? Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${chat['unread_count']}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            contactName: chat['contact_name'],
                            contactPhoneNumber: chat['contact_phone'],
                            loggedInPhoneNumber: widget.loggedInPhoneNumber,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactsPage(loggedInPhoneNumber: widget.loggedInPhoneNumber)),
        );
      },
      backgroundColor: Colors.orange,
      child: Icon(Icons.contact_emergency, color: Colors.white),
    ),
    backgroundColor: Colors.black,
  );
}
}