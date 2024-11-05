import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profil.dart';

class SettingMenu extends StatefulWidget {
  final String loggedInPhoneNumber;

  SettingMenu({required this.loggedInPhoneNumber});

  @override
  _SettingMenuState createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  String name = 'Loading...';
  String bio = 'Loading...';
  String photo = 'default.jpg'; // Use a default photo URL

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.13:3000/api/users/profile/${widget.loggedInPhoneNumber}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'] ?? 'No Name';
          bio = data['bio'] ?? 'No Bio';
          photo = data['photo'] ?? 'default.jpg'; // Ensure to use default if not available
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            // Profile Section
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange.shade200,
                      backgroundImage: NetworkImage('http://192.168.2.13:3000/$photo'), // Fetch from API
                      child: photo.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.orange.shade800,
                            )
                          : null,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            bio,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.qr_code, color: Colors.orange, size: 30),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey[800], height: 1),

            // Settings Options
            _buildSettingItem(Icons.key, 'Account', 'Privacy, security, change number'),
            _buildSettingItem(Icons.chat, 'Chats', 'Theme, wallpapers, chat history'),
            _buildSettingItem(Icons.notifications, 'Notifications', 'Message, group & call tones'),
            _buildSettingItem(Icons.data_usage, 'Storage and data', 'Network usage, auto-download'),
            _buildSettingItem(Icons.help_outline, 'Help', 'Help center, contact us, privacy policy'),
            _buildSettingItem(Icons.group, 'Invite a friend', 'Share BeeChat with friends'),

            // App Info
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MyApp from Opangsky',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 26),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: () {
        // Handle tap
      },
    );
  }
}
