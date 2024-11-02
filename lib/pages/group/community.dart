import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {
              // Aksi kamera
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Aksi pencarian
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('New community'),
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
          Container(
            color: Colors.grey[900],
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.people, color: Colors.white, size: 25),
              ),
              title: Text(
                'New Community',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Aksi new community
              },
            ),
          ),
          Divider(height: 1, color: Colors.grey[800]),
          SizedBox(height: 16), // Menambahkan jarak
          Container(
            color: Colors.grey[900],
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.group, color: Colors.white, size: 25),
                  ),
                  title: Text(
                    'Flutter Developers',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Community announcements and important updates',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.group, color: Colors.white, size: 25),
                  ),
                  title: Text(
                    'UI/UX Design Group',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Share your design ideas and get feedback',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk menambah chat baru
        },
        backgroundColor: Colors.orange.shade200,
        child: Icon(Icons.message, color: Colors.white),
      ),
      backgroundColor: Colors.black,
    );
  }
}
