import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/app/login.dart';
import 'dart:convert';
import '../contact/contact.dart';
import '/pages/settingmenu.dart';
import 'chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String loggedInPhoneNumber;

  ChatPage({required this.loggedInPhoneNumber});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> chats = [];
  bool isLoading = true;
  Timer? _timer; // Timer for polling

  @override
  void initState() {
    super.initState();
    fetchChats();
    startPolling(); // Start polling when the widget initializes
  }

  // Function to start polling
  void startPolling() {
    // Cancel any existing timer to avoid multiple instances
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    // Start a periodic timer for polling every 4 seconds
    _timer = Timer.periodic(Duration(seconds: 4), (Timer t) {
      if (mounted) {
        fetchChats();
      }
    });
  }

  Future<void> fetchChats() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.2.13:3000/api/chat/list/${widget.loggedInPhoneNumber}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> chatList = json.decode(response.body);
        print(chatList); // Debugging line
        if (mounted) {
          setState(() {
            chats = chatList;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      print('Error fetching chats: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // Optional: handle retry mechanism here if needed
    }
  }

  Future<void> markAsRead(String contactPhoneNumber) async {
    try {
      await http.patch(
        Uri.parse(
            'http://192.168.2.13:3000/api/chat/read/${widget.loggedInPhoneNumber}/$contactPhoneNumber'),
      );
      fetchChats(); // Refresh chats after marking as read
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> deleteChat(String contactPhoneNumber) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://192.168.2.13:3000/api/chat/delete/${widget.loggedInPhoneNumber}/$contactPhoneNumber'),
      );

      if (response.statusCode == 200) {
        fetchChats(); // Fetch chats again after deletion
      } else {
        throw Exception('Failed to delete chat');
      }
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }

  void confirmDeleteChat(String contactPhoneNumber, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Chat'),
          content: Text('Are you sure you want to delete this chat?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Start delete animation
                setState(() {
                  chats[index]['isDeleting'] = true;
                });
                Future.delayed(Duration(milliseconds: 300), () {
                  deleteChat(contactPhoneNumber);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

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
            icon: Icon(Icons.camera_alt_outlined,
                color: Color.fromARGB(255, 187, 133, 52)),
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
                  MaterialPageRoute(
                    builder: (context) => SettingMenu(
                        loggedInPhoneNumber: widget.loggedInPhoneNumber),
                  ),
                );
              } else if (value == 'Logout') {
                logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                'New group',
                'New broadcast',
                'Linked devices',
                'Starred messages',
                'Settings',
                'Logout',
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
                    print('Chat: $chat');
                    final unreadCount = chat['total_unread'] is String
                        ? int.tryParse(chat['total_unread']) ?? 0
                        : chat['total_unread'] ?? 0;
                    final String photoPath =
                        chat['photo']?.replaceAll('\\', '/') ?? 'default.jpg';
                    final String imageUrl =
                        'http://192.168.2.13:3000/$photoPath';
                    bool isDeleting = chat['isDeleting'] ?? false;

                    return AnimatedOpacity(
                      opacity: isDeleting ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 300),
                      child: SizeTransition(
                        sizeFactor: isDeleting
                            ? AlwaysStoppedAnimation(0.0)
                            : AlwaysStoppedAnimation(1.0),
                        axis: Axis.vertical,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
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
                                    '$unreadCount',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : null,
                          onTap: () {
                            markAsRead(chat['contact_phone']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailPage(
                                  contactName:
                                      chat['contact_name'] ?? 'Unknown Contact',
                                  contactPhoneNumber:
                                      chat['contact_phone'] ?? '',
                                  loggedInPhoneNumber:
                                      widget.loggedInPhoneNumber,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            confirmDeleteChat(chat['contact_phone'], index);
                          },
                        ),
                      ),
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

  // Fungsi untuk menangani logout
    void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
