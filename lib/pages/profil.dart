import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
            // Profile Picture Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.orange.shade200,
                      child: Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 20,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Name Section
            ListTile(
              leading: Icon(Icons.person, color: Colors.orange),
              title: Text(
                'Name',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                'Your Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(Icons.edit, color: Colors.orange),
            ),
            Divider(color: Colors.grey[800]),

            // About Section
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.orange),
              title: Text(
                'About',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                'Hey there! I am using BeeChat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(Icons.edit, color: Colors.orange),
            ),
            Divider(color: Colors.grey[800]),

            // Phone Section
            ListTile(
              leading: Icon(Icons.phone, color: Colors.orange),
              title: Text(
                'Phone',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '+1 234 567 890',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Divider(color: Colors.grey[800]),

            // Username Section
            ListTile(
              leading: Icon(Icons.alternate_email, color: Colors.orange),
              title: Text(
                'Username',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '@username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(Icons.edit, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
