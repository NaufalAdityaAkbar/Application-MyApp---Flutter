import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calls',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.orange),
            onPressed: () {
              // Aksi untuk kamera
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.orange),
            onPressed: () {
              // Aksi untuk pencarian
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.orange),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Clear call log'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Settings'),
                value: 2,
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.orange.shade200,
              child: Icon(Icons.link, color: Colors.white, size: 22),
            ),
            title: Text(
              'Create call link',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Share a link for your WhatsApp call',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[900],
            child: Text(
              'Recent',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.orange.shade200,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            title: Text(
              'User 1',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.call_made, color: Colors.green, size: 15),
                SizedBox(width: 5),
                Text(
                  'Today, 10:30 AM',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.orange),
              onPressed: () {
                // Aksi untuk memulai panggilan
              },
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.orange.shade200,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            title: Text(
              'User 2',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.call_received, color: Colors.red, size: 15),
                SizedBox(width: 5),
                Text(
                  'Yesterday, 8:45 PM',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.videocam, color: Colors.orange),
              onPressed: () {
                // Aksi untuk memulai video call
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk membuat panggilan baru
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add_call, color: Colors.white),
      ),
      backgroundColor: Colors.black,
    );
  }
}
