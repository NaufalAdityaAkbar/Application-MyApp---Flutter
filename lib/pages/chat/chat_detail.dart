import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../contact/contact.dart';
import 'package:myapp/pages/settingmenu.dart';
import 'chat.dart'; // Pastikan Anda mengimpor halaman detail chat yang benar

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
        Uri.parse(
            'http://localhost:3000/api/chat/list/${widget.loggedInPhoneNumber}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> chatList = json.decode(response.body);
        print(chatList); // Debugging line
        setState(() {
          chats = chatList;
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

  Future<void> markAsRead(String contactPhoneNumber) async {
    try {
      await http.patch(
        Uri.parse(
            'http://localhost:3000/api/chat/read/${widget.loggedInPhoneNumber}/$contactPhoneNumber'),
      );
      fetchChats(); // Refresh chats after marking as read
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

 @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'MyApp',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 187, 133, 52),
        ),
      ),
      backgroundColor: Color.fromARGB(218, 254, 250, 224),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.camera_alt_outlined, color: Color.fromARGB(255, 187, 133, 52)),
          onPressed: () {
            // Action for camera
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: Color.fromARGB(255, 187, 133, 52)),
          onPressed: () {
            // Action for searching chats
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Color.fromARGB(255, 187, 133, 52)),
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
            : ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  // Pastikan nilai total_unread diterima dengan benar
                  print('Chat: $chat'); // Debugging line to inspect chat data
                  final unreadCount = chat['total_unread'] is String
                      ? int.tryParse(chat['total_unread']) ?? 0
                      : chat['total_unread'] ?? 0;

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          chat['photo'] ?? 'https://via.placeholder.com/150'),
                    ),
                    title: Text(
                      chat['contact_name'] ?? 'Unknown Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    subtitle: Text(
                      chat['message'] ?? 'No message available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: (unreadCount > 0)
                        ? Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 187, 133, 52),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$unreadCount', // Menampilkan jumlah pesan yang belum dibaca
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null, // Jika tidak ada pesan yang belum dibaca, tidak tampilkan apa-apa
                    onTap: () {
                      markAsRead(chat['contact_phone']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            contactName: chat['contact_name'] ?? 'Unknown Contact',
                            contactPhoneNumber: chat['contact_phone'] ?? '',
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
          MaterialPageRoute(
            builder: (context) =>
                ContactsPage(loggedInPhoneNumber: widget.loggedInPhoneNumber),
          ),
        );
      },
      backgroundColor: Color.fromARGB(255, 187, 133, 52),
      child: Icon(Icons.contact_emergency, color: Colors.white),
    ),
    backgroundColor: Color.fromARGB(218, 254, 250, 224),
  );
}
}
